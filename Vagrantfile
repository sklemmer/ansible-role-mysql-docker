# -*- mode: ruby -*-
# vi: set ft=ruby :

suites=['mariadb', 'mysql']

Vagrant.configure(2) do |config|
  config.ssh.insert_key = false

  suites.each_with_index do |suite, index|
    ip = 100 + index
    config.vm.network :private_network, ip: "192.168.98.#{ip}"
    config.vm.hostname = "#{suite}.test"

      # Enable provisioning with Ansible.
    config.vm.provision "ansible" do |ansible|
      ansible.playbook = "tests/docker.yml"
    end
    config.vm.provider :virtualbox do |v|
      v.name = "#{suite}.test"
      v.memory = 512
      v.cpus = 2
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      v.customize ["modifyvm", :id, "--ioapic", "on"]

      config.vm.provision "ansible" do |ansible|
        ansible.playbook = "tests/#{suite}/test.yml"
      end
    end
  end

end
