PHP := docker-compose exec php-fpm

.DEFAULT_GOAL := help
help:
	@grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'
.PHONY: help

##
## Project
##

install: .env.local up vendor ## Install application.
.PHONY: install

up: ## Start development docker environment.
	docker-compose up -d
.PHONY: up

stop: ## Stop development docker environment.
	docker-compose stop
.PHONY: stop

rebuild: ## Rebuild development docker environment.
	docker-compose down
	docker-compose up -d --build
.PHONY: rebuild

vendor: composer.lock ## Install composer dependencies.
	${PHP} composer install
.PHONY: vendor

.env.local: .env
	@if [ -f .env.local ]; \
	then\
		echo '\033[1;41m/!\ The .env file has changed. Please update your .env.local file with these changes.\033[0m';\
	else\
		echo cp .env .env.local;\
		cp .env .env.local;\
	fi
.PHONY: .env.local

shell: ## Opens shell in container with PHP.
	${PHP} bash
.PHONY: shell