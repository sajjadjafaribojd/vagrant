# Generated by the protocol buffer compiler.  DO NOT EDIT!
# Source: proto/vagrant_server/server.proto for package 'hashicorp.vagrant'

require 'grpc'
require 'proto/vagrant_server/server_pb'

module Hashicorp
  module Vagrant
    module Vagrant
      # The service that is implemented for the server backend.
      class Service

        include GRPC::GenericService

        self.marshal_class_method = :encode
        self.unmarshal_class_method = :decode
        self.service_name = 'hashicorp.vagrant.Vagrant'

        # GetVersionInfo returns information about the server. This RPC call does
        # NOT require authentication. It can be used by clients to determine if they
        # are capable of talking to this server.
        rpc :GetVersionInfo, ::Google::Protobuf::Empty, ::Hashicorp::Vagrant::GetVersionInfoResponse
        rpc :UpsertBasis, ::Hashicorp::Vagrant::UpsertBasisRequest, ::Hashicorp::Vagrant::UpsertBasisResponse
        rpc :GetBasis, ::Hashicorp::Vagrant::GetBasisRequest, ::Hashicorp::Vagrant::GetBasisResponse
        rpc :FindBasis, ::Hashicorp::Vagrant::FindBasisRequest, ::Hashicorp::Vagrant::FindBasisResponse
        rpc :ListBasis, ::Google::Protobuf::Empty, ::Hashicorp::Vagrant::ListBasisResponse
        # ListTasks returns the tasks.
        rpc :ListTasks, ::Hashicorp::Vagrant::ListTasksRequest, ::Hashicorp::Vagrant::ListTasksResponse
        # GetTask returns a task
        rpc :GetTask, ::Hashicorp::Vagrant::GetTaskRequest, ::Hashicorp::Vagrant::Task
        # GetLatestRelease returns the most recent successfully completed
        # task within the given scope.
        rpc :GetLatestTask, ::Hashicorp::Vagrant::GetLatestTaskRequest, ::Hashicorp::Vagrant::Task
        # UpsertRelease updates or inserts a task.
        rpc :UpsertTask, ::Hashicorp::Vagrant::UpsertTaskRequest, ::Hashicorp::Vagrant::UpsertTaskResponse
        # UpsertProject upserts the project.
        rpc :UpsertProject, ::Hashicorp::Vagrant::UpsertProjectRequest, ::Hashicorp::Vagrant::UpsertProjectResponse
        # GetProject returns the project.
        rpc :GetProject, ::Hashicorp::Vagrant::GetProjectRequest, ::Hashicorp::Vagrant::GetProjectResponse
        rpc :FindProject, ::Hashicorp::Vagrant::FindProjectRequest, ::Hashicorp::Vagrant::FindProjectResponse
        # ListProjects returns a list of all the projects. There is no equivalent
        # ListApplications because applications are a part of projects and you
        # can use GetProject to get more information about the project.
        rpc :ListProjects, ::Google::Protobuf::Empty, ::Hashicorp::Vagrant::ListProjectsResponse
        # UpsertMachine upserts a machine with a project. If the machine
        # is already registered this does nothing.
        rpc :UpsertMachine, ::Hashicorp::Vagrant::UpsertMachineRequest, ::Hashicorp::Vagrant::UpsertMachineResponse
        rpc :GetMachine, ::Hashicorp::Vagrant::GetMachineRequest, ::Hashicorp::Vagrant::GetMachineResponse
        rpc :FindMachine, ::Hashicorp::Vagrant::FindMachineRequest, ::Hashicorp::Vagrant::FindMachineResponse
        rpc :ListMachines, ::Google::Protobuf::Empty, ::Hashicorp::Vagrant::ListMachinesResponse
        # GetLogStream reads the log stream for a deployment. This will immediately
        # send a single LogEntry with the lines we have so far. If there are no
        # available lines this will NOT block and instead will return an error.
        # The client can choose to retry or not.
        rpc :GetLogStream, ::Hashicorp::Vagrant::GetLogStreamRequest, stream(::Hashicorp::Vagrant::LogBatch)
        # Set a single configuration item for the application.
        rpc :SetConfig, ::Hashicorp::Vagrant::ConfigSetRequest, ::Hashicorp::Vagrant::ConfigSetResponse
        # Retrieve merged configuration values for a specific scope. You can determine
        # where a configuration variable was set by looking at the scope field on
        # each variable.
        rpc :GetConfig, ::Hashicorp::Vagrant::ConfigGetRequest, ::Hashicorp::Vagrant::ConfigGetResponse
        # QueueJob queues a job for execution by a runner. This will return as
        # soon as the job is queued, it will not wait for execution.
        rpc :QueueJob, ::Hashicorp::Vagrant::QueueJobRequest, ::Hashicorp::Vagrant::QueueJobResponse
        # CancelJob cancels a job. If the job is still queued this is a quick
        # and easy operation. If the job is already completed, then this does
        # nothing. If the job is assigned or running, then this will signal
        # the runner about the cancellation but it may take time.
        #
        # This RPC always returns immediately. You must use GetJob or GetJobStream
        # to wait on the status of the cancellation.
        rpc :CancelJob, ::Hashicorp::Vagrant::CancelJobRequest, ::Google::Protobuf::Empty
        # GetJob queries a job by ID.
        rpc :GetJob, ::Hashicorp::Vagrant::GetJobRequest, ::Hashicorp::Vagrant::Job
        # INTERNAL: ListJobs lists all the jobs the server has processed. This
        # is not yet ready for public use.
        rpc :_ListJobs, ::Hashicorp::Vagrant::ListJobsRequest, ::Hashicorp::Vagrant::ListJobsResponse
        # ValidateJob checks if a job appears valid. This will check the job
        # structure itself (i.e. missing fields) and can also check to ensure
        # the job is assignable to a runner.
        rpc :ValidateJob, ::Hashicorp::Vagrant::ValidateJobRequest, ::Hashicorp::Vagrant::ValidateJobResponse
        # GetJobStream opens a job event stream for a running job. This can be
        # used to listen for terminal output and other events of a running job.
        # Multiple listeners can open a job stream.
        rpc :GetJobStream, ::Hashicorp::Vagrant::GetJobStreamRequest, stream(::Hashicorp::Vagrant::GetJobStreamResponse)
        # GetRunner gets information about a single runner.
        rpc :GetRunner, ::Hashicorp::Vagrant::GetRunnerRequest, ::Hashicorp::Vagrant::Runner
        # GetServerConfig sets configuration for the Vagrant server.
        rpc :GetServerConfig, ::Google::Protobuf::Empty, ::Hashicorp::Vagrant::GetServerConfigResponse
        # SetServerConfig sets configuration for the Vagrant server.
        rpc :SetServerConfig, ::Hashicorp::Vagrant::SetServerConfigRequest, ::Google::Protobuf::Empty
        # CreateSnapshot creates a new database snapshot.
        rpc :CreateSnapshot, ::Google::Protobuf::Empty, stream(::Hashicorp::Vagrant::CreateSnapshotResponse)
        # RestoreSnapshot performs a database restore with the given snapshot.
        # This API doesn't do a full online restore, it only stages the restore
        # for the next server start to finalize the restore. See the arguments for
        # more information.
        rpc :RestoreSnapshot, stream(::Hashicorp::Vagrant::RestoreSnapshotRequest), ::Google::Protobuf::Empty
        # BootstrapToken returns the initial token for the server. This can only
        # be requested once on first startup. After initial request this will
        # always return a PermissionDenied error.
        rpc :BootstrapToken, ::Google::Protobuf::Empty, ::Hashicorp::Vagrant::NewTokenResponse
        # Generate a new invite token that users can exchange for a login token.
        rpc :GenerateInviteToken, ::Hashicorp::Vagrant::InviteTokenRequest, ::Hashicorp::Vagrant::NewTokenResponse
        # Generate a new login token that users can use to login directly.
        rpc :GenerateLoginToken, ::Google::Protobuf::Empty, ::Hashicorp::Vagrant::NewTokenResponse
        # Exchange a invite token for a login token.
        rpc :ConvertInviteToken, ::Hashicorp::Vagrant::ConvertInviteTokenRequest, ::Hashicorp::Vagrant::NewTokenResponse
        # ----------------------------------------------------------------------
        # Runner endpoints. These are expected to be called only by a runner.
        # These are not meant to be public endpoints.
        # ----------------------------------------------------------------------
        #
        # RunnerConfig is called to register a runner and receive the configuration
        # for the runner. The response is a stream so that the configuration can
        # be updated later.
        rpc :RunnerConfig, stream(::Hashicorp::Vagrant::RunnerConfigRequest), stream(::Hashicorp::Vagrant::RunnerConfigResponse)
        # RunnerJobStream is called by a runner to request a single job for
        # execution and update the status of that job.
        rpc :RunnerJobStream, stream(::Hashicorp::Vagrant::RunnerJobStreamRequest), stream(::Hashicorp::Vagrant::RunnerJobStreamResponse)
      end

      Stub = Service.rpc_stub_class
    end
  end
end