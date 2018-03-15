# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

init: build_front build_worker ## Build all images (must be run before up)

start: ## Start all services in dettached mode (see logs).
	docker-compose up -d

up: ## Same as start but in foreground mode (not dettached).
	docker-compose up

stop: ## Stop all services.
	docker-compose stop

restart: stop start # Stop and start all or some services (see start and stop)

logs: ## Logs of all services. Or some services by setting s as in 'make logs s=app'.
ifdef s
	docker-compose logs -f --tail="1" $(s)
else
	docker-compose logs -f --tail="1"
endif

status: ## Status of containers created/running.
	@docker-compose ps

running: ## Same as status but only display running containers.
	@docker-compose ps | grep -v Exit

build_front: ## Build front-app injecting shared dir
	cp -r ./shared front-app/
	docker-compose build front-app
	rm -rf front-app/shared

build_worker: ## Build front-app injecting shared dir
	cp -r ./shared worker/
	docker-compose build worker
	rm -rf worker/shared
