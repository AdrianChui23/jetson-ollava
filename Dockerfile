FROM dustynv/ollama:r36.2.0
RUN wget https://bootstrap.pypa.io/get-pip.py
RUN python3 get-pip.py

RUN apt-get update

RUN pip3 install opencv-python==4.9.0.80 numpy==1.26.4 
RUN wget http://ports.ubuntu.com/ubuntu-ports/pool/main/m/mysql-8.0/libmysqlclient21_8.0.39-0ubuntu0.22.04.1_arm64.deb
RUN apt install -y ./libmysqlclient21_8.0.39-0ubuntu0.22.04.1_arm64.deb


RUN apt-get install -y  libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libgstreamer-plugins-bad1.0-dev gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav gstreamer1.0-tools gstreamer1.0-x gstreamer1.0-alsa gstreamer1.0-gl gstreamer1.0-gtk3 gstreamer1.0-qt5 gstreamer1.0-pulseaudio

COPY gstreamer_install.sh .
RUN bash gstreamer_install.sh 

RUN pip3 install ollama
RUN apt-get install ffmpeg libsm6 libxext6  -y
RUN apt-get install -y qt6-base-dev
RUN pip3 install PyQt6
RUN apt-get install -y libxcb-cursor-dev

RUN apt-get install -y kmod libcanberra-gtk-module
RUN pip3 install pyttsx3

RUN wget https://repo.download.nvidia.com/jetson/common/pool/main/c/cudnn/libcudnn8_8.9.4.25-1+cuda12.2_arm64.deb
RUN apt install -y ./libcudnn8_8.9.4.25-1+cuda12.2_arm64.deb
RUN pip3 install adafruit-circuitpython-busdevice   adafruit-circuitpython-servokit adafruit-circuitpython-register  adafruit-circuitpython-motor Adafruit-Blinka  Jetson.GPIO face_recognition dlib
RUN apt-get install -y espeak alsa-utils
RUN pip3 install piper-tts
RUN pip3 install onnxruntime-gpu
WORKDIR /jetson-ollava
