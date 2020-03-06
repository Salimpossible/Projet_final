# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "centos/7"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  config.vm.network "forwarded_port", guest: 8080, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  config.vm.synced_folder "./data", "/vagrant_data", create: true

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:

  config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
    vb.memory = "4096"
    vb.cpus= "2"
  end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  config.vm.provision "shell", inline: <<-SHELL
    yum update
    #installation d'ansible
      yum -y install epel-release
      yum -y install python-pip
      pip install ansible
      ansible --version

    # installation des outils tree et net-tools
      yum -y install tree
      yum -y install net-tools
    
    # installation de git2.16
      yum install -y https://centos7.iuscommunity.org/ius-release.rpm
      yum install -y git2u-all
   
    # installation terraform
       curl -s -LO https://releases.hashicorp.com/terraform/0.12.21/terraform_0.12.21_linux_amd64.zip
       yum install -y unzip
       unzip terraform_0.12.21_linux_amd64.zip
       mv terraform /usr/bin
       rm -f terraform_0.12.21_linux_amd64.zip
 
    # installation az cli
      # rpm --import https://packages.microsoft.com/keys/microsoft.asc
      # echo -e "[azure-cli]\nname=Azure CLI\nbaseurl=https://packages.microsoft.com/yumrepos/azure-cli\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/azure-cli.repo
      # yum install -y azure-cli
    
    # installation de docker
      # yum install -y yum-utils device-mapper-persistent-data lvm2
      # yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
      # yum install -y docker-ce
      # systemctl enable docker
      # systemctl start docker
      # usermod -aG docker vagrant

    # installation de docker-compose
      # curl -L "https://github.com/docker/compose/releases/download/1.25.3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/bin/docker-compose
      # chmod +x /usr/bin/docker-compose

    # installation de kubectl
      # curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
      # chmod +x ./kubectl
      # mv ./kubectl /usr/bin/kubectl

    # installation de java12
      # curl -s -LO https://download.java.net/java/GA/jdk12.0.1/69cfe15208a647278a19ef0990eea691/12/GPL/openjdk-12.0.1_linux-x64_bin.tar.gz
      # tar -xzf openjdk-12.0.1_linux-x64_bin.tar.gz -C /opt/
      # echo 'export JAVA_HOME=/opt/jdk-12.0.1' > /etc/profile.d/jdk12.sh
      # echo 'export PATH=$PATH:$JAVA_HOME/bin' >> /etc/profile.d/jdk12.sh

    # installation de java8
      #yum install -y java-1.8.0-openjdk-devel 
    
    # installation de maven-3.6.3  
      # curl -s -LO https://www-us.apache.org/dist/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz
      # tar -xzf apache-maven-3.6.3-bin.tar.gz -C /opt/
      # echo 'export MAVEN_HOME=/opt/apache-maven-3.6.3' > /etc/profile.d/mvn.sh
      # echo 'export PATH=$PATH:$MAVEN_HOME/bin' >> /etc/profile.d/mvn.sh
    
    # installation de jenkins en service
      # curl -s -LO http://mirrors.jenkins.io/war-stable/latest/jenkins.war
      # mkdir -p /usr/lib/jenkins
      # mv jenkins.war /usr/lib/jenkins/jenkins.war
      # mkdir -p /data/
      # useradd --system -md /data/jenkins jenkins
      # echo -e '[Unit]\nDescription=Jenkins Daemon\nAfter=network.target\n\n[Service]\nType=simple\nEnvironment="JENKINS_HOME=/data/jenkins"\nExecStart=/usr/bin/java -jar /usr/lib/jenkins/jenkins.war\nUser=jenkins\n\n[Install]\nWantedBy=multi-user.target' > /etc/systemd/system/jenkins.service
      # systemctl daemon-reload
      # systemctl start jenkins.service
      # systemctl status jenkins.service
      # systemctl enable jenkins.service
  SHELL
end
