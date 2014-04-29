# -*- mode: ruby -*-
# # vi: set ft=ruby :

# NOTE: This monkey-patching of the coreos guest plugin is a terrible
# hack that needs to be removed once the upstream plugin works with
# alpha CoreOS images.

require 'tempfile'
require 'ipaddr'
require Vagrant.source_root.join("plugins/guests/coreos/cap/configure_networks.rb")

BASE_CLOUD_CONFIG = <<EOF
#cloud-config

coreos:
    units:
EOF

NETWORK_UNIT = <<EOF
      - name: %s
        runtime: no
        content: |
          [Match]
          Name=%s

          [Network]
          Address=%s
EOF

# Borrowed from http://stackoverflow.com/questions/1825928/netmask-to-cidr-in-ruby
IPAddr.class_eval do
  def to_cidr
    self.to_i.to_s(2).count("1")
  end
end

module VagrantPlugins
  module GuestCoreOS
    module Cap
      class ConfigureNetworks
        include Vagrant::Util

        def self.configure_networks(machine, networks)
          cfg = BASE_CLOUD_CONFIG
          machine.communicate.tap do |comm|

            # Read network interface names
            interfaces = []
            comm.sudo("ifconfig | grep enp0 | cut -f1 -d:") do |_, result|
              interfaces = result.split("\n")
            end

            # Configure interfaces
            # FIXME: fix matching of interfaces with IP adresses
            networks.each do |network|
              iface_num = network[:interface].to_i
              iface_name = interfaces[iface_num]
              cidr = IPAddr.new('255.255.255.0').to_cidr
              address = "%s/%s" % [network[:ip], cidr]
              unit_name = "50-%s.network" % [iface_name]
              unit = NETWORK_UNIT % [unit_name, iface_name, address]

              cfg = "#{cfg}#{unit}"
            end

            temp = Tempfile.new("coreos-vagrant")
            temp.binmode
            temp.write(cfg)
            temp.close

            path = "/var/tmp/networks.yml"
            path_esc = path.gsub("/", "-")
            comm.upload(temp.path, path)
            comm.sudo("systemctl start system-cloudinit@#{path_esc}.service")
          end
        end
      end
    end
  end
end
