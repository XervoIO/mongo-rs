#!/bin/bash
# Collection of system config settings to improve high network throughput servers

cp /etc/sysctl.conf /etc/sysctl.$(date +%Y%m%d-%H:%M:%S)
# Append the following settings to /etc/sysctl.conf
cat <<EOF>> /etc/sysctl.conf

fs.file-max = 250000
fs.inotify.max_user_instances = 1048576
fs.inotify.max_user_watches = 1048576
net.core.somaxconn = 65000
# Prevent against the common 'syn flood attack'
net.ipv4.tcp_syncookies = 1
# Set maximum number of packets, queued on the INPUT side, when the interface receives packets faster than kernel can process them.
net.core.netdev_max_backlog = 5000
net.core.wmem_max = 12582912
net.core.rmem_max = 12582912
net.ipv4.tcp_rmem = 10240 87380 12582912
net.ipv4.tcp_wmem = 10240 87380 12582912
# this gives the kernel more memory for tcp
# which you need with many (100k+) open socket connections
net.ipv4.tcp_mem = 50576   64768   98152
net.core.netdev_max_backlog = 2500
# Increase ephemeral tcp ports
net.ipv4.ip_local_port_range = 18000  65535
# Reuse tcp_wait sockets if available
net.ipv4.tcp_tw_reuse = 1
# Increase the number of NAT connections
net.ipv4.netfilter.ip_conntrack_max = 196608
# Increase local port range
kernel.pid_max = 4194303

EOF

# Reload sysctl.conf
/sbin/sysctl -p /etc/sysctl.conf

echo 1048576 > /proc/sys/fs/inotify/max_user_instances
echo 1048576 > /proc/sys/fs/inotify/max_user_watches
echo 250000 > /proc/sys/fs/file-max

sed -i 's|# End of file| *       soft    nofile  250000 \n&|' /etc/security/limits.conf
sed -i 's|# End of file| *       hard    nofile  250000 \n&|' /etc/security/limits.conf
sed -i 's|# End of file| root       soft    nofile  250000 \n&|' /etc/security/limits.conf
sed -i 's|# End of file| root       hard    nofile  250000 \n&|' /etc/security/limits.conf
