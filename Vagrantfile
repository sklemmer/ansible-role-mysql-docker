# -*- mode: ruby -*-
# vi: set ft=ruby :

suites = ['mariadb', 'mysql']
role = "ansible-role-mysql-docker"

Vagrant.configure("2") do |config|
  suites.each_with_index do |suite, index|

   config.vm.box = "ubuntu/xenial64"

    # Enable provisioning with Ansible.
    config.vm.define "#{suite}" do |b|
      ip = 100 + index
      b.vm.hostname = "#{suite}.local"
      b.vm.network :private_network, ip: "192.168.98.#{ip}"
      b.vm.synced_folder ".", "/vagrant", disabled: true
      b.vm.synced_folder ".", "/#{role}"

      b.vm.provider :virtualbox do |v|
        v.name = "#{suite}.local"
        v.memory = 512
        v.cpus = 2
        v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        v.customize ["modifyvm", :id, "--ioapic", "on"]
      end

      $script = <<-SCRIPT
      apt update
      apt install -y python python-apt python-pip
      pip install ansible==2.4
      SCRIPT
      b.vm.provision "shell", inline: $script

      b.vm.provision "ansible_local" do |ansible|
        ansible.playbook = "tests/docker.yml"

        ansible.provisioning_path = "/#{role}"
        ansible.limit = "test"
        ansible.inventory_path = "tests/inventory"
        ansible.config_file = "tests/ansible.cfg"
        ansible.galaxy_roles_path = "tests/external/"
        ansible.galaxy_role_file = "tests/requirements.yml"
      end
      b.vm.provision "ansible_local" do |ansible|
        ansible.playbook = "tests/#{suite}/test.yml"

        ansible.provisioning_path = "/#{role}"
        ansible.limit = "test"
        ansible.inventory_path = "tests/inventory"
        ansible.config_file = "tests/ansible.cfg"
      end
    end
  end

end
