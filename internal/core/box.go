package core

import (
	"archive/tar"
	"errors"
	"io"
	"io/ioutil"
	"net/http"
	"os"
	"path/filepath"
	"sync"
	"time"

	"github.com/hashicorp/go-hclog"
	"github.com/hashicorp/go-multierror"
	"github.com/hashicorp/go-version"
	"github.com/hashicorp/vagrant-plugin-sdk/core"
	"github.com/hashicorp/vagrant/internal/server/proto/vagrant_server"
	"github.com/mitchellh/mapstructure"
	"google.golang.org/protobuf/types/known/timestamppb"
)

// Number of seconds to wait between checks for box updates
const BoxUpdateCheckInterval = 3600

type Box struct {
	basis  *Basis
	box    *vagrant_server.Box
	logger hclog.Logger
	m      sync.Mutex
}

func NewBox(opts ...BoxOption) (b *Box, err error) {
	b = &Box{
		logger: hclog.L(),
		box:    &vagrant_server.Box{},
	}

	for _, opt := range opts {
		if oerr := opt(b); oerr != nil {
			err = multierror.Append(err, oerr)
		}
	}

	if b.basis == nil {
		return nil, errors.New("Basis must be specified for the box")
	}

	if b.box.Directory == "" {
		return nil, errors.New("Box directory must be specified for the box")

	}

	metadataFile := filepath.Join(b.box.Directory, "metadata.json")
	if _, err := os.Stat(metadataFile); err != nil {
		return nil, err
	}

	data, err := os.ReadFile(metadataFile)
	if err != nil {
		return nil, err
	}
	metadata, err := LoadBoxMetadata(data)
	if err != nil {
		return nil, err
	}
	mapstructure.Decode(metadata, &b.box.Metadata)
	b.box.Id = b.box.Name + "-" + b.box.Version + "-" + b.box.Provider
	b.Save()
	return
}

type BoxOption func(*Box) error

func BoxWithLogger(log hclog.Logger) BoxOption {
	return func(b *Box) (err error) {
		b.logger = log
		return
	}
}

func BoxWithBasis(basis *Basis) BoxOption {
	return func(b *Box) (err error) {
		b.basis = basis
		return
	}
}

func BoxWithName(name string) BoxOption {
	return func(b *Box) (err error) {
		b.box.Name = name
		return
	}
}

func BoxWithVersion(ver string) BoxOption {
	return func(b *Box) (err error) {
		_, err = version.NewVersion(ver)
		if err != nil {
			return err
		}
		b.box.Version = ver
		return
	}
}

func BoxWithProvider(provider string) BoxOption {
	return func(b *Box) (err error) {
		b.box.Provider = provider
		return
	}
}

func BoxWithMetadataUrl(url string) BoxOption {
	return func(b *Box) (err error) {
		b.box.MetadataUrl = url
		return
	}
}

func BoxWithDirectory(dir string) BoxOption {
	return func(b *Box) (err error) {
		if _, err := os.Stat(dir); err != nil {
			return err
		}
		b.box.Directory = dir
		return
	}
}

func BoxWithBox(box *vagrant_server.Box) BoxOption {
	return func(b *Box) (err error) {
		b.box = box
		return
	}
}

func (b *Box) loadMetadata() (metadata *BoxMetadata, err error) {
	resp, err := http.Get(b.box.MetadataUrl)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	data, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return nil, err
	}
	return LoadBoxMetadata(data)
}

func (b *Box) matches(box core.Box) (bool, error) {
	name, err := box.Name()
	if err != nil {
		return false, err
	}
	version, err := box.Version()
	if err != nil {
		return false, err
	}
	provider, err := box.Provider()
	if err != nil {
		return false, err
	}
	if b.box.Name == name &&
		b.box.Version == version &&
		b.box.Provider == provider {
		return true, nil
	}
	return false, nil
}

// Check if a box update check is allowed. Returns true if the
// BOX_UPDATE_CHECK_INTERVAL has passed.
func (b *Box) AutomaticUpdateCheckAllowed() (allowed bool, err error) {
	now := time.Now()
	lastUpdate := b.box.LastUpdate.AsTime()
	if lastUpdate.Add(BoxUpdateCheckInterval * time.Second).After(now) {
		return false, nil
	}
	b.box.LastUpdate = timestamppb.Now()
	b.Save()
	return true, nil
}

// This deletes the box. This is NOT undoable.
func (b *Box) Destroy() (err error) {
	return os.RemoveAll(b.box.Directory)
}

func (b *Box) Directory() (path string, err error) {
	return b.box.Directory, nil
}

// Checks if the box has an update and returns the metadata, version,
// and provider. If the box doesn't have an update that satisfies the
// constraints, it will return nil.
func (b *Box) HasUpdate(version string) (updateAvailable bool, err error) {
	metadata, err := b.loadMetadata()
	if err != nil {
		return false, err
	}
	versionConstraint := ""
	if version == "" {
		versionConstraint = "> " + b.box.Version
	} else {
		versionConstraint = version + ", " + "> " + b.box.Version
	}
	result, err := metadata.Version(
		versionConstraint,
		&BoxVersionProvider{Name: b.box.Provider},
	)
	if err != nil {
		return false, err
	}
	if result == nil {
		return false, nil
	}
	return true, nil
}

// Checks if this box is in use according to the given machine
// index and returns the entries that appear to be using the box.
func (b *Box) InUse(index core.TargetIndex) (inUse bool, err error) {
	targets, err := index.All()
	if err != nil {
		return false, err
	}
	for _, t := range targets {
		m, err := t.Specialize((*core.Machine)(nil))
		if err != nil {
			continue
		}
		machineBox, err := m.(*Machine).Box()
		if err != nil {
			return false, err
		}
		ok, err := b.matches(machineBox)
		if err != nil {
			return false, err
		}
		if ok {
			return true, nil
		}
	}
	return false, nil
}

func (b *Box) Metadata() (metadata core.BoxMetadataMap, err error) {
	meta, err := b.loadMetadata()
	if err != nil {
		return nil, err
	}
	return metadata, mapstructure.Decode(meta, &metadata)
}

func (b *Box) MetadataURL() (url string, err error) {
	return b.box.MetadataUrl, nil
}

func (b *Box) Name() (name string, err error) {
	return b.box.Name, nil
}

func (b *Box) Provider() (name string, err error) {
	return b.box.Provider, nil
}

// This repackages this box and outputs it to the given path.
func (b *Box) Repackage(outputPath string) (err error) {
	b.logger.Trace("repackaging box", b.box.Name,
		"to", outputPath)

	tarFile, err := os.Create(outputPath)
	if err != nil {
		return err
	}
	defer tarFile.Close()
	tw := tar.NewWriter(tarFile)
	defer tw.Close()

	err = filepath.Walk(b.box.Directory, func(path string, info os.FileInfo, err error) error {
		header, err := tar.FileInfoHeader(info, path)
		if err != nil {
			return err
		}
		if err := tw.WriteHeader(header); err != nil {
			return err
		}
		if !info.IsDir() {
			data, err := os.Open(path)
			if err != nil {
				return err
			}
			if _, err := io.Copy(tw, data); err != nil {
				return err
			}
		}
		return nil
	})
	if err != nil {
		return err
	}

	return
}

func (b *Box) Version() (version string, err error) {
	return b.box.Version, nil
}

func (b *Box) Compare(box core.Box) (int, error) {
	name, err := box.Name()
	if err != nil {
		return 0, err
	}
	ver, err := box.Version()
	if err != nil {
		return 0, err
	}
	provider, err := box.Provider()
	if err != nil {
		return 0, err
	}

	if b.box.Name == name && b.box.Provider == provider {
		boxVersion, err := version.NewVersion(b.box.Version)
		if err != nil {
			return 0, nil
		}
		otherVersion, err := version.NewVersion(ver)
		if err != nil {
			return 0, nil
		}

		res := otherVersion.Compare(boxVersion)
		return res, nil
	}
	return 0, errors.New("Box name and provider does not match, can't compare")
}

func (b *Box) ToProto() *vagrant_server.Box {
	return b.box
}

func (b *Box) Save() error {
	b.m.Lock()
	defer b.m.Unlock()
	b.logger.Trace("saving box to db",
		"box", b.box.Name)

	_, err := b.basis.client.UpsertBox(
		b.basis.ctx,
		&vagrant_server.UpsertBoxRequest{Box: b.box},
	)
	if err != nil {
		b.logger.Trace("filed to save box",
			"box", b.box.Name)
	}
	return err
}

var _ core.Box = (*Box)(nil)