#!/bin/bash
# Demonstrate how read actually works
source "$(pwd)/spinner.sh"
echo Please add the IP of worker for configure a k8s cluster!
read IP01 
echo Please the hostname for the $IP01
read HOSTNAME01 
echo Thanks... Please the info for second worker
echo Great! please add the second IP of worker for configure a k8s cluster!
read IP02 
echo Please the hostname for the $IP02
read HOSTNAME02 
echo Thanks... Please the info for third worker
echo Great! please add the third IP of worker for configure a k8s cluster!
read IP03
echo Please the hostname for the $IP03
read HOSTNAME03
echo Your first IP and hostname was: $IP01 $HOSTNAME01
echo Your second IP and hostname was: $IP02 $HOSTNAME02
echo Your third IP and hostname was: $IP03 $HOSTNAME03
echo wait 🕛 ...
start_spinner '🔥need build the /etc/hosts files sleeping for 2 secs...'
sleep 2
cat >> /etc/hosts <<EOF
$IP01 $HOSTNAME01
$IP02 $HOSTNAME02
$IP02 $HOSTNAME03
EOF
stop_spinner $?
echo "\r❤️ $2.... Finished!"
ssh-keygen -t rsa 
ssh-copy-id root@$HOSTNAME01
expect "Password:"
send "password\r"
interact
ssh-copy-id root@$HOSTNAME02
expect "Password:"
send "password\r"
interact
ssh-copy-id root@$HOSTNAME03
expect "Password:"
send "password\r"
interact
echo -ne "\r❤️ $2.... Amazing set path and workdir!"
start_spinner '🔥  set path and workdir sleeping for 2 secs...'
echo 'PATH=/opt/k8s/bin:$PATH' >>/root/.bashrc
source /root/.bashrc
stop_spinner $?
echo -ne "\r❤️ $2.... Amazing now i need install some packages!"
start_spinner '🔥 running update..'
apt update 
apt install -y chrony conntrack ipvsadm ipset jq iptables curl sysstat libseccomp-dev  wget socat git
stop_spinner $?
echo "\r❤️ disable iptables!"
iptables -F && iptables -X && iptables -F -t nat && iptables -X -t nat && iptables -P FORWARD ACCEPT
echo run the command on $HOSTNAME02 and $HOSTNAME03
for s in $HOSTNAME02 $HOSTNAME03
do
   ssh root@${s} iptables -F && iptables -X && iptables -F -t nat && iptables -X -t nat && iptables -P FORWARD ACCEPT 
done
echo "\r❤️ forget iptables!"
start_spinner '🔥  set path and workdir sleeping for 2 secs...'
echo look now i put to sleeping the swap partion on $HOSTNAME01 $HOSTNAME02 $HOSTNAME03
swapoff -a && sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
echo run the command on $HOSTNAME02 and $HOSTNAME03
for s in $HOSTNAME02 $HOSTNAME03
do
   ssh root@${s} swapoff -a && sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

done
stop_spinner $?
echo dejemos algunas cosas guashi guashi en el kernel de todos los workers

cat > kubernetes.conf <<EOF
net.bridge.bridge-nf-call-iptables=1
net.bridge.bridge-nf-call-ip6tables=1
net.ipv4.ip_forward=1
net.ipv4.neigh.default.gc_thresh1=1024
net.ipv4.neigh.default.gc_thresh1=2048
net.ipv4.neigh.default.gc_thresh1=4096
vm.swappiness=0
vm.overcommit_memory=1
vm.panic_on_oom=0
fs.inotify.max_user_instances=8192
fs.inotify.max_user_watches=1048576
fs.file-max=52706963
fs.nr_open=52706963
net.ipv6.conf.all.disable_ipv6=1
net.netfilter.nf_conntrack_max=2310720
EOF
cp kubernetes.conf  /etc/sysctl.d/kubernetes.conf
sysctl -p /etc/sysctl.d/kubernetes.conf
echo run the command on $HOSTNAME02 and $HOSTNAME03
for s in $HOSTNAME02 $HOSTNAME03
do
   scp kubernetes.conf root@${s}:/etc/sysctl.d/ 
   ssh root@${s} sysctl -p /etc/sysctl.d/kubernetes.conf
done
echo ❤️ super estamos a 7989745 lineas de terminar!

echo 🕛 la hora del sistema UTC y habilitar la sincro 
timedatectl set-timezone UTC && systemctl enable chronyd && systemctl start chronyd

echo run the command on $HOSTNAME02 and $HOSTNAME03
for s in $HOSTNAME02 $HOSTNAME03
do
   ssh root@${s} timedatectl set-timezone UTC && systemctl enable chronyd && systemctl start chronyd
done
echo creamos el workdir
mkdir -p /opt/k8s/{bin,work} /etc/{kubernetes,etcd}/cert
echo run the command on $HOSTNAME02 and $HOSTNAME03
for s in $HOSTNAME02 $HOSTNAME03
do
   ssh root@${s} mkdir -p /opt/k8s/{bin,work} /etc/{kubernetes,etcd}/cert
done
echo super estamos a 928849494 de  terminar!
