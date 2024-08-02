#!/usr/bin/env bash
sudo xhost +si:localuser:root
sudo docker run --runtime nvidia -it --rm \
	--network host \
	--volume /tmp/argus_socket:/tmp/argus_socket \
	--volume /etc/enctune.conf:/etc/enctune.conf \
	--volume /etc/nv_tegra_release:/etc/nv_tegra_release \
	--volume /tmp/nv_jetson_model:/tmp/nv_jetson_model \
	--volume /var/run/dbus:/var/run/dbus \
	--volume /var/run/avahi-daemon/socket:/var/run/avahi-daemon/socket \
	--volume /var/run/docker.sock:/var/run/docker.sock \
	--volume /home/adrian/jetson-containers/data:/data \
	--device /dev/snd \
	--device /dev/bus/usb \
	--device /dev/i2c-0 \
	--device /dev/i2c-1 \
	--device /dev/i2c-2 \
	--device /dev/i2c-4 \
	--device /dev/i2c-5 \
	--device /dev/i2c-7 \
	--device /dev/i2c-9 \
	-v $(pwd):/jetson-ollava \
        --privileged \
	--user 0:0 \
        -v /proc/device-tree/compatible:/proc/device-tree/compatible \
        -v /proc/device-tree/chosen:/proc/device-tree/chosen \
        -v $(pwd)/data:/jetson-inference/data \
        -e DISPLAY=:0 -v /tmp/.X11-unix/:/tmp/.X11-unix \
        --device /dev/video0  --device /dev/video1 --device /dev/gpiochip0 \
	adrian-chui/jetson-ollava:1.0.0


