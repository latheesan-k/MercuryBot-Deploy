# Deploy MercuryBot to VPS Instance

### Minimum Server Requirement

```
* OS: Ubuntu
* RAM: 256 MB
* CPU: 1 Core
* DISK: 8 GB
```

Instructions for **Ubuntu**. You must **copy & paste the entire command blocks** below when running the commands, not one line at a time.

### 1) VPS Preparation

For obvious security reason, you should NOT run this application as `root` user. Setup an unprivileaged user account with sudo access using the following command:

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

Lastly setup ssh public key authentication by following this guide: https://serverpilot.io/docs/how-to-use-ssh-public-key-authentication

Login as `mercury` (newly setup user) and continue with the remaining steps below.

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

MercuryBot will be running on: https://your-server-ip

Verify the application running correctly using the following `curl` command:

```shell
curl --insecure --location --request GET 'https://your-server-ip' \
--header 'X-API-USER: dev' \
--header 'X-API-PASS: dev'
```

You should see a response like this:

```json
{"status":200,"data":{"message":"Welcome to MercuryBot 1.0.0","version":"cardano-cli 1.27.0 - linux-x86_64 - ghc-8.10","build":"git rev 8fe46140a52810b6ca456be01d652ca08fe730bf"}}
```

### 5) Available Make Commands

* `up` Turn on / restart the application
* `down` Turn off the application
* `upgrade` Download the latest version & restart the application
* `status` View the status of the running application
* `stats` View the resource usage (CPU, RAM, IO etc...) by the application
* `logs` View application logs
* `shell` Drop into running application's container shell
* `install` Installs docker
* `ssl` Generates new apache self-signed certificates
