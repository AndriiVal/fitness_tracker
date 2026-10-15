# Fitness Tracker

A personal **Ruby on Rails** web application for logging workouts, managing exercises, and tracking training activity.

This repository is a learning/portfolio project, not a production-ready fitness platform.

## Features

- **User accounts:** sign up, sign in/out, and password recovery using Devise.
- **Workout management:** create, view, edit, and delete workouts with a name and date.
- **Exercise catalog:** create, browse, edit, and delete exercises with names and descriptions.
- **Training sets:** add exercises to workouts, record repetitions and weight (kg), and edit or remove sets.
- **Weekly overview:** view a pie chart showing the number of workouts per weekday for the current week.
- **Responsive UI foundations:** Rails views styled with Bootstrap.

Workouts are associated with the signed-in user. The exercise catalog is currently shared across authenticated users.

## Tech stack

| Area | Technology |
| --- | --- |
| Language | Ruby 3.2.2 |
| Framework | Ruby on Rails 7.0.8 |
| Database | PostgreSQL / Active Record |
| Authentication | Devise |
| Styling | Bootstrap 5, Sass |
| Charts and date grouping | Chartkick, Groupdate |
| JavaScript | Importmap, Turbo, Stimulus |
| Web server | Puma |
| Testing | Rails built-in Minitest scaffolding |

Versions above reflect the repository's Ruby version file and committed Gemfile/Gemfile.lock, rather than a newly verified production environment.

## Getting started (local development)

### Prerequisites

- **Ruby 3.2.2**, installed using a Ruby version manager such as rbenv, asdf, or mise
- **Bundler**
- **PostgreSQL**, running locally
- PostgreSQL client development headers and a C/C++ build toolchain to compile native gems

For example, on Ubuntu/Debian you can install the PostgreSQL and native build dependencies with:

```bash
sudo apt update
sudo apt install -y postgresql libpq-dev build-essential
sudo systemctl start postgresql
```

Make sure your local PostgreSQL role can create databases and authenticate as your OS user. The existing `config/database.yml` uses local PostgreSQL defaults, without an explicit username, password, or host.

If your PostgreSQL installation does **not** already have a role matching your Linux username, you can create one (requires local PostgreSQL administrative access):

```bash
sudo -u postgres createuser --createdb "$USER"
```

Skip that command if the role already exists. Alternatively, configure `config/database.yml` or provide a suitable `DATABASE_URL` for your local database.

### Install and run

```bash
git clone https://github.com/AndriiVal/fitness_tracker.git
cd fitness_tracker

# Select Ruby 3.2.2 in your version manager first.
bundle install
bin/rails db:prepare
bin/rails server
```

Open **http://localhost:3000** in a browser. Create an account, then add exercises, workouts, and training sets.

The repository also includes `bin/setup`, which installs gems and prepares the local database.

> **Note:** This repository does not currently include a Dockerfile or Docker Compose configuration. The instructions above are for a local Ruby/PostgreSQL installation. They have been checked against the committed configuration but were not executed in a clean environment as part of this documentation update.

## Using the app

1. **Register or sign in** using the Devise authentication screens.
2. **Create exercises** with a name and description.
3. **Create a workout** with its name and date.
4. **Add training sets** to that workout, selecting an exercise and entering repetitions and weight.
5. **View the dashboard** to see the current week's workout counts by weekday.

## Tests

Run the Rails test suite with:

```bash
bin/rails test
```

**Current test status:** Some model test files are still generated placeholders, so the repository does not yet have comprehensive automated coverage. Passing the existing suite should not be treated as a production-readiness guarantee.

## Project structure

```text
app/
  controllers/       # Workout, exercise, and training-set actions
  models/            # User, Workout, Exercise, TrainingSet
  views/             # Rails HTML views and forms
config/
  database.yml       # Local PostgreSQL configuration
  routes.rb          # Devise and resource routes
db/
  migrate/           # Database migrations
  schema.rb          # Schema snapshot
test/                # Rails test scaffolding
```

## Current scope and limitations

- Built as a **personal project**; no production deployment process is documented or verified.
- No bundled Docker setup.
- Exercise records form a shared catalog rather than per-user private exercises.
- Automated tests and CI need further development before this can be presented as a production-quality application.

## License

See [LICENSE](LICENSE) for the repository's GNU General Public License v3 text.
