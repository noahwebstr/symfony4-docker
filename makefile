# Constants
DOCKER_COMPOSE = docker-compose
DOCKER = docker

## Environments
ENV_PHP = $(DOCKER) exec notepad_php-fpm

# Tools
COMPOSER = composer

# Main
start: docker-compose.yml
	    $(DOCKER_COMPOSE) build --no-cache
	    $(DOCKER_COMPOSE) up -d --build --remove-orphans --force-recreate
	    make install
	    make cache-clear

restart: docker-compose.yml
	    $(DOCKER_COMPOSE) up -d --build --remove-orphans --no-recreate
	    make install
	    make cache-clear

stop: docker-compose.yml
	    $(DOCKER_COMPOSE) stop

clean: ## Allow to delete the generated files and clean the project folder
	    $(ENV_PHP) rm -rf .env ./vendor

## PHP|Composer commands
install: composer.json
	     $(COMPOSER) install -a -o
	     $(COMPOSER) clear-cache
	     $(COMPOSER) dump-autoload --optimize --classmap-authoritative

update: composer.lock
	     $(COMPOSER) update -a -o

require: composer.json
	    $(COMPOSER) req $(PACKAGE) -a -o

require-dev: composer.json
	    $(COMPOSER) req --dev $(PACKAGE) -a -o

remove: composer.json
	    $(COMPOSER) remove $(PACKAGE) -a -o

autoload: composer.json
	    $(COMPOSER) dump-autoload -a -o

## Symfony commands
cache-clear: var/cache
	     $(ENV_PHP) rm -rf ./var/cache/*

router: config/routes
	    $(ENV_PHP) bin/console debug:router

## Tools commands
php-cs: ## Allow to use php-cs-fixer
	    $(ENV_PHP) php-cs-fixer fix $(FOLDER) --rules=@$(RULES)

deptrac: ## Allow to use the deptrac analyzer
	    $(ENV_PHP) deptrac
