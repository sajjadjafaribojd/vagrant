# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: internal/server/proto/ruby-server.proto

require 'google/protobuf'

require 'google/protobuf/empty_pb'
require 'google/protobuf/any_pb'
Google::Protobuf::DescriptorPool.generated_pool.build do
  add_file("internal/server/proto/ruby-server.proto", :syntax => :proto3) do
    add_message "hashicorp.vagrant.GetPluginsResponse" do
      repeated :plugins, :message, 1, "hashicorp.vagrant.Plugin"
    end
    add_message "hashicorp.vagrant.Plugin" do
      optional :name, :string, 1
      optional :type, :enum, 2, "hashicorp.vagrant.Plugin.Type"
    end
    add_enum "hashicorp.vagrant.Plugin.Type" do
      value :COMMAND, 0
      value :COMMUNICATOR, 1
      value :GUEST, 2
      value :HOST, 3
      value :PROVIDER, 4
      value :PROVISIONER, 5
      value :SYNCED_FOLDER, 6
    end
    add_message "hashicorp.vagrant.ParseVagrantfileRequest" do
      optional :path, :string, 1
    end
    add_message "hashicorp.vagrant.ParseVagrantfileResponse" do
      optional :vagrantfile, :message, 1, "hashicorp.vagrant.Vagrantfile"
    end
    add_message "hashicorp.vagrant.Provisioner" do
      optional :name, :string, 1
      optional :config, :message, 2, "google.protobuf.Any"
    end
    add_message "hashicorp.vagrant.MachineConfig" do
      optional :name, :string, 1
      optional :box, :string, 2
      repeated :provisioners, :message, 3, "hashicorp.vagrant.Provisioner"
    end
    add_message "hashicorp.vagrant.CommunicatorSSH" do
      optional :guest_port, :string, 1
      optional :shell, :string, 2
    end
    add_message "hashicorp.vagrant.CommunicatorWinrm" do
      optional :username, :string, 1
      optional :password, :string, 2
      optional :host, :string, 3
      optional :port, :string, 4
      optional :guest_port, :string, 5
    end
    add_message "hashicorp.vagrant.CommunicatorWinssh" do
      optional :guest_port, :string, 1
      optional :shell, :string, 2
      optional :upload_directory, :string, 3
    end
    add_message "hashicorp.vagrant.Communicator" do
      oneof :type do
        optional :ssh, :message, 1, "hashicorp.vagrant.CommunicatorSSH"
        optional :winrm, :message, 2, "hashicorp.vagrant.CommunicatorWinrm"
        optional :winssh, :message, 3, "hashicorp.vagrant.CommunicatorWinssh"
      end
    end
    add_message "hashicorp.vagrant.Vagrantfile" do
      optional :path, :string, 1
      optional :raw, :string, 2
      optional :current_version, :string, 3
      repeated :machine_configs, :message, 4, "hashicorp.vagrant.MachineConfig"
      repeated :communicators, :message, 5, "hashicorp.vagrant.Communicator"
    end
  end
end

module Hashicorp
  module Vagrant
    GetPluginsResponse = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("hashicorp.vagrant.GetPluginsResponse").msgclass
    Plugin = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("hashicorp.vagrant.Plugin").msgclass
    Plugin::Type = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("hashicorp.vagrant.Plugin.Type").enummodule
    ParseVagrantfileRequest = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("hashicorp.vagrant.ParseVagrantfileRequest").msgclass
    ParseVagrantfileResponse = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("hashicorp.vagrant.ParseVagrantfileResponse").msgclass
    Provisioner = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("hashicorp.vagrant.Provisioner").msgclass
    MachineConfig = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("hashicorp.vagrant.MachineConfig").msgclass
    CommunicatorSSH = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("hashicorp.vagrant.CommunicatorSSH").msgclass
    CommunicatorWinrm = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("hashicorp.vagrant.CommunicatorWinrm").msgclass
    CommunicatorWinssh = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("hashicorp.vagrant.CommunicatorWinssh").msgclass
    Communicator = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("hashicorp.vagrant.Communicator").msgclass
    Vagrantfile = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("hashicorp.vagrant.Vagrantfile").msgclass
  end
end
