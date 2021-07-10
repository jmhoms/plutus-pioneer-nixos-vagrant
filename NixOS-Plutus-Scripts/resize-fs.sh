echo -e "yes\n100%" | parted /dev/sda ---pretend-input-tty unit % resizepart 1
resize2fs /dev/sda1
