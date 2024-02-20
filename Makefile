# These targets were made with unix in mind.  If you are not on unix, feel free to update for support.
-include .env
.DEFAULT_GOAL = dev

env:
	@export DB_PORT=${DB_PORT}
	@export DB_USER=${DB_USER}
	@export DB_PASSWORD=${DB_PASSWORD}
	@export DB_NAME=${DB_NAME}
	@echo 'db environment updated'

dev: env
	@yarn run dev

db-migrate: env
	bin/rails db:migrate

db-seed: env
	bin/rails db:seed

init: env
	@command -v yarn > /dev/null 2>&1 || { echo >&2 "please install yarn first"; exit 1; }
	bin/rails db:setup
	bin/rails db:migrate
	bin/rails db:seed
