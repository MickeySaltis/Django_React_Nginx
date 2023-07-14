# Variables Modulable
PROJET = 
APPLICATION = 
CONTAINER_DJANGO = backend
CONTAINER_ID = 
IMAGE_ID = 

## Variables Fixe
DOCKER = docker 
DOCKER_COMPOSE = docker-compose
DJANGO_ADMIN = django-admin
EXEC = ${DOCKER} exec -w /django ${CONTAINER_DJANGO}
PIP = ${EXEC} pip
PYTHON = ${EXEC} python
MANAGE = ${PYTHON} manage.py

## —— 🔥 App ——
create-project: ## Créer un projet
	$(DOCKER_COMPOSE) run --rm app $(DJANGO_ADMIN) startproject $(PROJET) .

create-app: ## Créer une application
	$(MANAGE) startapp $(APPLICATION)

superUser: ## Créer un super utilisateur
	$(MANAGE) createsuperuser

console: ## Console Django
	$(DOCKER) exec -it $(CONTAINER_DJANGO) sh

freeze-requirements: ## Mettre à jours requirements.txt
	$(PIP) freeze > requirements.txt

migrations: ## Créer une migration
	$(MANAGE) makemigrations

migrate: ## Migrer
	$(MANAGE) migrate

install-pillow: ## Installer Pillow
	$(PIP) install Pillow


## —— 🐳 Docker ——
build: ## Construire images
	$(MAKE) docker-build
docker-build: ## Construire images
	$(DOCKER_COMPOSE) build

start: ## Démarrer les container / Start app
	$(MAKE) docker-start 
docker-start: 
	$(DOCKER_COMPOSE) up -d

stop: ## Arrêter les containers / Stop app
	$(MAKE) docker-stop
docker-stop: 
	$(DOCKER_COMPOSE) stop
	@$(call RED,"The containers are now stopped.")

stopAll: ## Arrêter tout les containers en cours
	$(DOCKER) stop $$(docker ps -a -q)

deleteContainers: ## Supprimer tout les containers
	$(DOCKER) container prune

deleteImages: ## Supprimer toutes les images
	$(DOCKER) image prune -a

delete-container: ## Supprimer un container
	$(DOCKER) rm $(CONTAINER_ID)

delete-image: ## Supprimer une image
	$(DOCKER) rmi $(IMAGE_ID)

## —— 🛠️  Others ——
chown: ## Chown
	sudo chown -R $$USER ./
	
help: ## Liste des commandes / List of commands
	@grep -E '(^[a-zA-Z0-9_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'