entrypoint := python3
network := dd-dev
project := docker-django

build:
	docker build --tag docker-django:dev .

make-test-network:
	@docker network inspect dd-dev >/dev/null || docker network create dd-dev

postgres-start: make-test-network
	docker run --rm \
		--network dd-dev \
		--name docker-django-postgres \
		--env POSTGRES_PASSWORD=secret \
		--env POSTGRES_DB=${project} \
		-d -p 127.0.0.1:5432:5432 \
		postgres

postgres-shell:
	docker run -it --rm --network dd-dev \
		--env PGPASSWORD=secret \
		postgres psql -h docker-django-postgres -U postgres -d docker-django

postgres-stop:
	docker kill docker-django-postgres

run: build make-test-network
	docker run --rm -it --name docker-django-service --publish 127.0.0.1:7500:80/tcp \
		--network dd-dev \
		--env-file=.env \
		-e PORT=80 \
		docker-django:dev

run-dev: build
	docker run --rm -it --name docker-django-service --publish 127.0.0.1:7500:80/tcp \
		--network dd-dev \
		--env-file=.env \
		-v $(CURDIR)/src:/code \
		-v docker-django-root:/root \
		--entrypoint ${entrypoint} \
		docker-django:dev -Wd /code/manage.py runserver 0.0.0.0:80

# Get shell in the container started by `make run`
shell:
	docker exec -it docker-django-service bash

# Get shell on a fresh container that isn't running the server
# The code directory is bound into the container so that any changes are persisted on the host
# This means you can run eg. ./manage.py makemigrations and commit the source that makemigrations generates
shell-only:
	docker run -it --rm \
		--network dd-dev \
		--env-file=.env \
		-v $(CURDIR)/src:/code \
		-v docker-django-root:/root \
		--entrypoint bash \
		docker-django:${dev}
