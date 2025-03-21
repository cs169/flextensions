# Flextensions

Back end/API for UC Berkeley EECS "Flextensions" software


[![Maintainability](https://api.codeclimate.com/v1/badges/8d99ec9a1784ddba34ac/maintainability)](https://codeclimate.com/github/cs169/flextensions/maintainability) 
[![Test Coverage](https://api.codeclimate.com/v1/badges/8d99ec9a1784ddba34ac/test_coverage)](https://codeclimate.com/github/cs169/flextensions/test_coverage) 
[![All Specs](https://github.com/cs169/flextensions/actions/workflows/main.yml/badge.svg)](https://github.com/cs169/flextensions/actions/workflows/main.yml) 
[![Accessibility Tests](https://github.com/cs169/flextensions/actions/workflows/a11y.yml/badge.svg)](https://github.com/cs169/flextensions/actions/workflows/a11y.yml)
[![RuboCop](https://github.com/cs169/flextensions/actions/workflows/rubocop.yml/badge.svg)](https://github.com/cs169/flextensions/actions/workflows/rubocop.yml)

 Live Heroku [Deployment Link](https://sp25-02-flextensions-4f5b4fbccd7f.herokuapp.com/)


## Installation

### Environment Variables

For the environment variables, you will need to configure on your local system (and any deployment machines) the following environment variables (recommended through a `.env` file at root):

- DB_PORT (default: 5432)
- DB_USER (default: postgres)
- DB_PASSWORD (default: password)
- DB_NAME (default: postgres)
- CANVAS_URL (no default; will error if not included)

#The following are for authentication purposes
CANVAS_CLIENT_ID (Private, depending on the developer key)
APP_KEY = (Private, depending on the developer key)
CANVAS_REDIRECT_URI = (Private, depending on the developer key and the environment)

Changing only the user and password then running `$make env` should be sufficient.

### Postgres Installation

#### MacOS

- `brew install postgresql chromedriver`
- Start postgres if necessary. `brew services start postgresql`

#### Linux/WSL

- `sudo apt install postgresql`
- Create a postgres user.
  - `sudo su - postgres` (to get into postgres shell)
  - `createuser --interactive --pwprompt` (in postgres shell)
  - Save `DB_USER` and `DB_PASSWORD` fields in the `.env` file.
- Start postgres if necessary. `pg_ctlcluster 12 main start`
  - Note: if you are using WSL2 on windows, the command to start postgres is `sudo service postgresql start`

### Stand Up Server

In order to stand up the server you must first install [Overmind](https://github.com/DarthSim/overmind).
  Development has been tested with overmind 2.4.0

With Overmind, you can run `$make dev` or `$make`

### Running Accessibility Tests

Run RSpec accessibility tests:
bundle exec rspec spec/ --tag a11y

Run Cucumber accessibility tests:
bundle exec cucumber features/ --tag @a11y

## Notes
There are now two separate instances of Canvas, each with it's own triad of prod/test/beta environments:
1. [bcourses.berkeley.edu](bcourses.berkeley.edu)
2. [ucberkeleysandbox.instructure.com](ucberkeleysandbox.instructure.com)

We recommend developing in this order:
1. [ucberkeleysandbox.instructure.com](ucberkeleysandbox.instructure.com) (no risk) - this is the one for which this repo currently has oauth2 keys (secrets)
2. [bcourses.test.instructure.com](bcourses.test.instructure.com) (no risk of impacting courses, but contains real data)
3. [bcourses.berkeley.edu](bcourses.berkeley.edu)
