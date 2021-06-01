.DEFAULT_GOAL := up

.PHONY: up
up:
	$(MAKE) down
	docker-compose up -d

.PHONY: down
down:
	docker-compose down --remove-orphans

.PHONY: upgrade
upgrade:
	docker-compose pull
	$(MAKE) up

.PHONY: status
status:
	docker-compose ps

.PHONY: stats
stats:
	docker stats mercury-bot

.PHONY: logs
logs:
	docker-compose logs -f --tail=100

.PHONY: shell
shell:
	docker exec -it mercury-bot bash

.PHONY: install
install:
	sudo apt-get remove docker docker-engine docker.io containerd runc -y
	sudo apt-get update && sudo sudo apt-get install -y
	sudo apt-get install apt-transport-https ca-certificates curl gnupg lsb-release -y
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
	echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
	sudo apt-get update && sudo apt-get install docker-ce docker-ce-cli containerd.io -y
	sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
	sudo chmod +x /usr/local/bin/docker-compose
	sudo usermod -aG docker ${USER}
	echo "Docker installed, now restart your server with [sudo reboot] command"

.PHONY: ssl
ssl:
	mkdir -p ssl
	cd ssl && openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout apache-selfsigned.key -out apache-selfsigned.crt
