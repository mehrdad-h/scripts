# ------------------------------------------
# Script to install openCV library for Torch
# ------------------------------------------
# Mehrdad Hosseinzadeh (mehrdad.hosseinzadeh@live.com)
#
# ----------
# Reference:
# ----------
# Main reference: http://docs.opencv.org/trunk/d7/d9f/tutorial_linux_install.html
#
# June 12, 2017: Tested on Ubunto 16.04 and 14.04
# June 16, 2017: Tested on a Cuda-Torch docker container by kiaxhin:
# https://hub.docker.com/r/kaixhin/cuda-torch/
#
# -----
# Usage
# -----
# cd to your desired directory and run the following code:
# bash install_OpenCV_Torch_script.sh 
#
# --------------------------------------------------------------------------------------
# ATTENTION: It's assumed that you have already installed Torch7 and CUDA on your system
# --------------------------------------------------------------------------------------

# 1. Keep everything updated and upgraded
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y dist-upgrade
sudo apt-get -y autoremove

# 2. Install Dependencies: 1st line: compiler  2nd line: required   3rd line: optional
sudo apt-get install -y build-essential
sudo apt-get install -y cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev
sudo apt-get install -y python-dev python-numpy libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libjasper-dev libdc1394-22-dev

# 3. You're gonna need these! Believe me
sudo apt-get install -y liblapacke-dev
sudo apt-get install -y libhdf5-7

# 4. Clone OpenCV: Currently OpenCV3.1.0 is the only version compatible with Torch. However, if you have CUDA 8.0 installed, you need the
#    following branch of OpenCV to install (official version has problem with CUDA 8.0):
#    https://github.com/daveselinger/opencv/tree/3.1.0-with-cuda8
#    The following line would git-clone it:
git clone -b 3.1.0-with-cuda8 https://github.com/daveselinger/opencv

# 5. Start installing OpenCV
cd opencv
mkdir build 
cd build

cmake -DWITH_QT=ON -DWITH_OPENGL=ON -DFORCE_VTK=ON -DWITH_TBB=ON -DWITH_GDAL=ON -DWITH_XINE=ON -DBUILD_EXAMPLES=ON ..
# If you encounter problem: CUDA_CUDA_LIBRARY not found use the following cmake command instead.
# Usually it's because the cuda has been found on the machine but the nvidia driver not found. This problems often happen when you
# use containers like docker which use the driver from host machine directly.
# reference: https://github.com/opencv/opencv/issues/6577#issuecomment-226685773
# cmake -DWITH_QT=ON -DWITH_OPENGL=ON -DFORCE_VTK=ON -DWITH_TBB=ON -DWITH_GDAL=ON -DWITH_XINE=ON -DBUILD_EXAMPLES=ON -DCUDA_CUDA_LIBRARY=/usr/local/cuda/lib64/stubs/libcuda.so .. 
# BTW, I'm not sure if it's -DCUDA_CUDA_LIBRARY=/usr/local/cuda/lib64/stubs/libcuda.so or -DCUDA_CUDA_LIBRARY=/usr/local/cuda-7.5/lib64/stubs/libcuda.so


make -j4
# Sometimes you may encounter a problem at make install stating that:
# /usr/bin/ld: cannot find -lcuda
# In this cases you need to make a symbolic link from the place you have already installed cuda to lib folder on your machine 
# (usually your docker container). In order to do so: execute this command:
# sudo ln -s /usr/local/cuda-7.5/lib64/stubs/libcuda.so /usr/lib/libcuda.so
# change the first path (the path to your cuda installation folder) as necessary
# The problem usually means that cuda cannot be found in regular place of libs which happen when you have installed cuda 
# but there's not nvidia driver available (like when you want to install openCV on a docker container
sudo make install
sudo ldconfig

# 6. Install OpenCV bindings for Torch
#    Reference: https://github.com/VisionLabs/torch-opencv/wiki/installation
luarocks install cv

# 7. Have fun!
#
#
# Some issue links which might be useful if you encounter the same problem
#  i) Lapack error   : http://answers.opencv.org/question/121651/fata-error-lapacke_h_path-notfound-when-building-opencv-32/
# ii) CUDA 8.0 error : https://github.com/opencv/opencv/issues/6677
# If you need to use OpenCV in other languages rather than Torch, you may take a look at:
# https://github.com/milq/milq/blob/master/scripts/bash/install-opencv.sh
# or:
# http://milq.github.io/install-opencv-ubuntu-debian/
# for a step-by-step guide to install OpenCV (not specifically for Torch) by Manuel Ignacio López Quintero
# some parts of this code is adopted from his guide. 