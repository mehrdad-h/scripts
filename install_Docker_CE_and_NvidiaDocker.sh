# Installation of Docker Community Edition (CE) on Ubuntu 
# Reference: https://docs.docker.com/engine/installation/linux/ubuntu/
# Recommended extra packages for Trusty 14.04
# Unless you have a strong reason not to, install the linux-image-extra-* packages,
# which allow Docker to use the aufs storage drivers.
#
# $ sudo apt-get update
#
# $ sudo apt-get install \
#    linux-image-extra-$(uname -r) \
#    linux-image-extra-virtual
#

# ------------------------
# A) Setup the repository
# ------------------------

# 1. Install packages to allow apt to use a repository over HTTPS:
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
	
# 2. Add Docker’s official GPG key:	
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# 3. Use the following command to set up the stable repository. You always need the stable repository,
# even if you want to install edge builds as well. for amd64 structures:
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# ------------------
# B) Install Docker
# ------------------

# 1. Update the apt package index.
sudo apt-get update

# 2. Install the latest version of Docker,# or go to the next step to install a specific version.
# Any existing installation of Docker is replaced.
sudo apt-get install -y docker-ce

# 3. Verify that Docker is installed correctly by running the hello-world image.
sudo docker run hello-world
# This command downloads a test image and runs it in a container. When the container runs,
# it prints an informational message and exits.

# The following commands will create a group and add current user to the group,
# so that there's no need to use sudo each time you want to user docker

# -------------------------
# C) Post Steps for Linux.
# -------------------------

# 1. Add a group named docker
sudo groupadd docker

# 2. Add your user to the docker group.
sudo usermod -aG docker $USER

# 3. Verify that you can run docker commands without sudo.
docker run hello-world

# -------------------------
# D) Install nvidia-docker
# -------------------------

# Reference: https://github.com/NVIDIA/nvidia-docker
# Assuming the NVIDIA drivers and Docker are properly installed

# 1. Install nvidia-docker and nvidia-docker-plugin
wget -P /tmp https://github.com/NVIDIA/nvidia-docker/releases/download/v1.0.1/nvidia-docker_1.0.1-1_amd64.deb
sudo dpkg -i /tmp/nvidia-docker*.deb && rm /tmp/nvidia-docker*.deb

# 2. Test nvidia-smi
sudo nvidia-docker run --rm nvidia/cuda nvidia-smi

# Accessing the host file system from a Docker container:
# (Reference: http://unitstep.net/blog/2015/12/21/accessing-the-host-filesystem-from-a-docker-container-on-os-x-or-windows/)
# $ docker run -v [host directory path]:[container directory path] -it [image name]