Vagrant.configure("2") do |config|
  config.vm.define "talos-node" do |node|
    node.vm.box = "generic/fedora38"
    node.vm.network "private_network", type: "dhcp"

    # Sync playbook, inventory, and roles directory to VM
    node.vm.synced_folder ".", "/home/vagrant", create: true

    # Install prerequisites, curl, pip & Ansible
    node.vm.provision "shell", inline: <<-SHELL
      sudo dnf update -y
      sudo dnf install -y curl python3 python3-venv python3-devel
      wget https://bootstrap.pypa.io/get-pip.py && python3 get-pip.py
      pip install ansible
      rm -rf get-pip.py*
      curl -Lo /usr/local/bin/talosctl https://github.com/siderolabs/talos/releases/download/v1.9.0/talosctl-linux-amd64
      chmod +x /usr/local/bin/talosctl
      talosctl gen config talos https://192.168.5.101:6443 --output-dir /home/vagrant/talos-configs
    SHELL

    # SSH key provisioning
    node.vm.provision "shell", inline: <<-SHELL
      mkdir -p /home/vagrant/.ssh
      echo "#{File.read("#{Dir.home}/.ssh/id_rsa.pub")}" >> /home/vagrant/.ssh/authorized_keys
      echo "#{File.read("#{Dir.home}/.ssh/id_rsa.pub")}" > /home/vagrant/.ssh/id_rsa.pub
      echo "#{File.read("#{Dir.home}/.ssh/id_rsa")}" > /home/vagrant/.ssh/id_rsa
      sudo chmod 600 /home/vagrant/.ssh/id_rsa
      sudo chmod 644 /home/vagrant/.ssh/id_rsa.pub
      sudo chmod 700 /home/vagrant/.ssh/authorized_keys
      chown -R vagrant:vagrant /home/vagrant/.ssh
    SHELL

    node.vm.provision "ansible_local" do |ansible|
      ansible.compatibility_mode = "2.0"
      ansible.playbook = "/home/vagrant/site.yaml"
      ansible.pip_install_cmd = "sudo dnf update -y && sudo dnf install -y python3 python3-venv python3-devel && wget https://bootstrap.pypa.io/get-pip.py && python3 get-pip.py"
      ansible.galaxy_command = "sudo ansible-galaxy install -r /home/vagrant/collections/requirements.yaml"
      ansible.install_mode = "pip"
    end
  end

  config.vm.provider "virtualbox" do |v|
    v.memory = 4096
    v.cpus = 2
    v.linked_clone = true
    v.gui = false
  end

  config.vm.boot_timeout = 600  
end