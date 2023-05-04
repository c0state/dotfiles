How to configure static IPs on Linux

Using netplan
* get the MAC address via `ifconfig`

`cat /etc/netplan/10-static-ip.yaml`

```
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
      match:
        macaddress: aa:bb:22:cc:44:99
      set-name: eth0
      dhcp4: no
      addresses:
        - 192.168.1.9/24
      routes:
        - to: default
          via: 192.168.1.1
      nameservers:
        addresses: [192.168.1.1]
```

