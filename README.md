# Deploy MercuryBot to VPS Instance

Instructions for Ubuntu. You must **copy & paste the entire command blocks** below, not one line at a time.

### 1) VPS Preparation

For obvious security reason, you should run this application as `root` user. Setup an unprivileaged user account with sudo access using the following command:

```shell
adduser --disabled-password --gecos '' mercury && \
echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
adduser mercury sudo && \
chown -R mercury:mercury /home/mercury/.*
```

Next, we'll install required initial tools:

```shell
apt-get install wget unzip make -y
```

Lastly setup ssh public key authentication by following this guide: https://serverpilot.io/docs/how-to-use-ssh-public-key-authentication and then login as `mercury` newly created user on your VPS to continue

### 2) Download Deployment Files

```shell
wget https://github.com/latheesan-k/MercuryBot-Deploy/archive/refs/heads/main.zip && \
unzip main.zip && \
mv MercuryBot-Deploy-main MercuryBot && \
rm -f main.zip
```

### 3) Install Dependencies (Docker & Self-Signed SSL Certificates)

```shell
cd MercuryBot && \
make install && \
make ssl
```

⚠️ _After installing the dependencies, don't forget to restart your server with `sudo reboot` command_

### 4) Run MercuryBot Application

Modify the `MercuryBot/docker-compose.yml` with appropriate settings:

```yaml
environment:
  API_USER: dev
  API_PASS: dev
  NETWORK: testnet
```

* `API_USER` Authentication username
* `API_PASS` Authentication password
* `NETWORK` Cardano network (use `testnet` or `mainnet`)

Execute the following command to boot up the application:

```shell
make up
```

Mercury bot will be running on: https://your-server-ip
