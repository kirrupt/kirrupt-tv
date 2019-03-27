#### install microk8s and kubectl
```bash
sudo snap install microk8s --classic
snap install kubectl --classic

# DNS is not installed by default
microk8s.enable dns
```

#### get KUBECONFIG file
```bash
microk8s.config
```

we need to modify:
  - `# certificate-authority-data` needs to be commented out
  - `insecure-skip-tls-verify: true` needs to be added
since cert is only valid for localhost

#### exec to mariadb container and import `seed.sql`
```bash
kubectl exec -it mariadb-59d648885f-kf9cn bash
```

#### caddy to proxy port `80` to `tv` service port
```
wget https://github.com/mholt/caddy/releases/download/v0.11.5/caddy_v0.11.5_linux_amd64.tar.gz
tar xvfz caddy_v0.11.5_linux_amd64.tar.gz
mv caddy /usr/local/bin/
chmod 755 /usr/local/bin/caddy
mv caddy.conf /etc/caddy/Caddyfile
mkdir -p /etc/caddy
mv caddy.conf /etc/caddy/Caddyfile
wget https://raw.githubusercontent.com/mholt/caddy/master/dist/init/linux-systemd/caddy.service
sudo cp caddy.service /etc/systemd/system/
sudo chown root:root /etc/systemd/system/caddy.service
sudo chmod 644 /etc/systemd/system/caddy.service
sudo setcap 'cap_net_bind_service=+ep' /usr/local/bin/caddy
sudo groupadd -g 33 www-data
sudo useradd   -g www-data --no-user-group   --home-dir /var/www --no-create-home   --shell /usr/sbin/nologin   --system --uid 33 www-data
sudo mkdir /etc/caddy
sudo chown -R root:root /etc/caddy
sudo mkdir /etc/ssl/caddy
sudo chown -R root:www-data /etc/ssl/caddy
sudo chmod 0770 /etc/ssl/caddy
touch /var/log/access.log
chmod 777 /var/log/access.log
```

##### /etc/caddy/Caddyfile:
```
staging.tv.kirrupt.com:80

tls off
log    /var/log/access.log
proxy  / 127.0.0.1:32721
```

```bash
sudo systemctl daemon-reload
sudo systemctl start caddy.service
sudo systemctl enable caddy.service
```
