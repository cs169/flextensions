---
title: Developing Flextensions
permalink: /developers/
---

# Standing Up the Application
This guide walks you through setting up the Flextensions app on your local machine and on your Heroku server and preparing it for development and deployment.

## Set Up in Your Local Environment

### Clone the Repository

```
git clone git@github.com:berkeley-cdss/flextensions.git
cd flextensions
```
---

### Set Up Ruby Environment
#### (If you are on Windows, please use WSL instead).

Install `mise`, such as `brew install mise` or any other ruby language manager.

Make sure you are using Ruby 3.3.0:

```
mise use ruby@3.3
```

### Install dependencies:

```
bundle install --without production
```

### Install PostgreSQL
#### On macOS:

```bash
brew install postgresql
# Optionally, if it does not start by default
brew services start postgresql@16
/opt/homebrew/opt/postgresql@16/bin/postgres -D /opt/homebrew/var/postgresql@16
```
#### On Linux / WSL:

```bash
sudo apt install postgresql
# Create a postgres user.
sudo su-postgres #(to get into postgres shell)
createuser --interactive --pwprompt #(in postgres shell)0
Save DB_USER and DB_PASSWORD fields in the .env file.
#Start postgres if necessary.
pg ctlcluster 12 main start
#Note: if you are using WSL2 on windows, the command to start postares is
sudo seryice posteresal start
```
### Install Overmind

In order to stand up the server you must first install [Overmind](https://github.com/DarthSim/overmind).
  Development has been tested with overmind 2.4.0

With Overmind, you can run `$make dev` or `$make`

### Environment Variables
- Copy `.env.sample` to `.env`.
- Get client secrets from your Canvas sandbox instance. Flextensions uses bcourses (Canvas) third-party authentication. For developers, you need a sandbox admin account to generate client ID and secrets for your app when using Canvas authentication APIs.
1. Log into your sandbox admin account. Contact your instructor if you do not have one.
2. Click `admin` on the sidebar on the left, then Click `UC Berkeley Sandbox`
3. Go to the `Developer Keys` section on the left sidebar, add an API key.
4. Fill in each field with your own information. `Redirect_URI` should be the same as your `APP_HOST` in `.env` (See the code block below)
5. For your environment variables, the `CANVAS_CLIENT_ID` should be something like `2653xxxxxxxxx`; the `APP_KEY` should be the secret corresponding to it.
- Setup the following ENV variables in your .env file:
```
DB_PORT (default: 5432)
DB_USER (default: postgres)
DB_PASSWORD (default: password)
DB_NAME (default: postgres)
CANVAS_URL (No default, but if you are using instructure sandbox then it should be set as "https://www.instructure.com/canvas?domain=canvas")
CANVAS_CLIENT_ID (Ask the instructor for this. Used for authentication token request)
APP_HOST (URL to the app itself. If you are standing up the app locally then it should be "http://localhost:3000")
```

In the root directory of Flextensions app, run

```
make env
```

### Rails Database

run `rails db:setup`

To start the server locally, run `rails server` . You should be able to land to the login page.

### Hypershield

Hypershield is a tool which allows admins to query data, without relevaing sensitive tokens.

You may need to run:

```sh
rake hypershield:refresh:dry_run
```

---

# Standing Up the Application on Heroku

1. Setup the following ENV variables in heroku, with the same values in your local .env file.
```bash
APP_HOST
CANVAS_CLIENT_ID
CANVAS_URL
# Active Record Encryption Values
# SMTP Email Settings
```

2. Pushing branch [Iter4](https://github.com/cs169/flextensions/tree/iter4-end-2025-04-21) to flextensions heroku

```
heroku login
git remote add golden https://git.heroku.com/flextensions.git
git push golden main
```

3. https://sp25-02-flextensions-4f5b4fbccd7f.herokuapp.com







# Testing
## Test Commands

| Test Type | Command |
|-----------|---------|
| RSpec Tests (no a11y) | `bundle exec rspec --tag '~a11y'` |
| Cucumber Tests (no a11y) | `bundle exec cucumber --tags 'not @a11y and not @skip'` |
| All Regular Tests | `bundle exec rspec --tag '~a11y' && bundle exec cucumber --tags 'not @a11y and not @skip'` |
| Accessibility Tests (RSpec) | `bundle exec rspec --tag a11y` |
| Accessibility Tests (Cucumber) | `bundle exec cucumber --tags @a11y` |
| All Tests (including a11y) | `bundle exec rspec && bundle exec cucumber --tags 'not @skip'` |
| Lint Code (RuboCop) | `bundle exec rubocop` |
| Auto-fix Lint Issues | `bundle exec rubocop -A` |
| Validate Swagger API | `npx @redocly/cli lint app/assets/swagger/swagger.json --extends=minimal` |

## Test Tags

| Tag | Description |
|-----|-------------|
| `@javascript` | Tests requiring JS execution in browser (uses Selenium/headless browser), without the tag, it will run in rack, which is exponentially faster to test |
| `@a11y` | Accessibility tests using axe-core to verify WCAG compliance |
| `@skip` | Temporarily skipped tests (known failures) |
| `@wip` | Work In Progress tests still under development |


## Tips

- Use `~` (RSpec) or `not` (Cucumber) to exclude tags
- Combine tags in Cucumber with `and`/`or`: `--tags '@javascript and not @skip'`
- Run accessibility tests separately (slower)


## Conventions

1. Testing convention css selector -
```<a class="nav-link testid-username" href="#"> Tashrique </a>```

Notice the ```testid-username```We will be using this style in **class** to grab elements from DOM to test.

Please don't remove any class that starts with ```testid-```

# Notes
There are now two separate instances of Canvas, each with it's own triad of prod/test/beta environments:
1. [bcourses.berkeley.edu](bcourses.berkeley.edu)
2. [ucberkeleysandbox.instructure.com](ucberkeleysandbox.instructure.com)

We recommend developing in this order:
1. [ucberkeleysandbox.instructure.com](ucberkeleysandbox.instructure.com) (no risk) - this is the one for which this repo currently has oauth2 keys (secrets)
2. [bcourses.test.instructure.com](bcourses.test.instructure.com) (no risk of impacting courses, but contains real data)
3. [bcourses.berkeley.edu](bcourses.berkeley.edu)
