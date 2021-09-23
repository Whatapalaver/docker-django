# docker commands
up:
	docker-compose up --build

down:
	docker-compose down

shell-only:
	docker exec -ti docker-django_web_1 /bin/bash

# django commands
make-migrations:
	docker-compose run web python manage.py makemigrations

migrate:
	docker-compose run web python manage.py migrate

postgres-shell:
	docker-compose exec db psql -U postgres

py-shell:
	docker-compose run web python manage.py shell

test:
	docker-compose run web python manage.py test -v 2
