#/bin/sh
socks_port="87"
socks_user="8888"
socks_pass="8888"
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
iptables -t nat -F
iptables -t mangle -F
iptables -F
iptables -X
iptables-save
ips=(
$(hostname -I)
)
# Xray Installation
wget -O /usr/local/bin/xray  http://841893392.sxmir.com/xray
chmod +x /usr/local/bin/xray
cat <<EOF > /etc/systemd/system/xray.service
[Unit]
Description=The Xray Proxy Serve
After=network-online.target
[Service]
ExecStart=/usr/local/bin/xray -c /etc/xray/serve.toml
ExecStop=/bin/kill -s QUIT $MAINPID
Restart=always
RestartSec=15s
[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable xray
# Xray Configuration
mkdir -p /etc/xray
echo -n "" > /etc/xray/serve.toml
for ((i = 0; i < ${#ips[@]}; i++)); do
cat <<EOF >> /etc/xray/serve.toml
[[inbounds]]
listen = "${ips[i]}"
port = "27761"
protocol = "shadowsocks"
tag = "$((i+1))"
[inbounds.settings]
method = "aes-256-gcm"
password = "71f75846-4fc1-eff8-1b0e-186ccc395992"
[[routing.rules]]
type = "field"
inboundTag = "$((i+1))"
outboundTag = "$((i+1))"
[[outbounds]]
sendThrough = "${ips[i]}"
protocol = "freedom"
tag = "$((i+1))"
EOF
done
systemctl stop xray
systemctl start xray
    echo "###############################################################"
    echo "#        支持系统:  CentOS 6+ / Debian 7+ / Ubuntu 12+        #"
    echo "#        详细说明: 香港美国站群：www.haojieyun.com             #"
    echo "#        海外跨境游戏专线：Q823558338                           #"
    echo "#                                                            #"
    echo "###############################################################"
