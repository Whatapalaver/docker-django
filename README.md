# Docker Django Setup for Rapid Testing

## Master branch

Initial setup of a django app using postgres.
Check out the Makefile for basic commands.

Switched away from docker-compose using Networks and Makefile commands.

## To run

- Start the database (in background) with `make postgres-start`
- Start the web container with `make run-dev`
- Open a shell within the running container `make shell` and from here run any migrations or other manage.py commands `./manage.py migrate`
- app should be visible at localhost:7500
