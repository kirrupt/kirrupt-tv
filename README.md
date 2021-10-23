# Kirrupt TV

## Development

### Requirements

* docker-compose
* make
* elixir
* node

macOS:
```bash
brew cask install docker
brew install elixir node
```

Linux/WSL2:
```bash
wget https://packages.erlang-solutions.com/erlang-solutions_2.0_all.deb && sudo dpkg -i erlang-solutions_2.0_all.deb
curl -fsSL https://deb.nodesource.com/setup_15.x | sudo -E bash -
sudo apt update
sudo apt install -y inotify-tools esl-erlang elixir nodejs

# For e2e tests
sudo apt install -y libgtk2.0-0 libgtk-3-0 libgbm-dev libnotify-dev libgconf-2-4 libnss3 libxss1 libasound2 libxtst6 xauth xvfb
```

### Getting started
Clone repository and run:
```bash
docker-compose up -d mariadb
make seed
```
to start and seed the database.

Run:
```bash
npm install
mix deps.get
make server
```
to start the server locally.

After application is started, you can go to http://localhost:8080.

#### Docker
Alternatively, you can run server via Docker:
```bash
# dev
docker-compose up dev

# or

# prod
docker-compose up prod
```

### fix formatting
```bash
mix format
```

### unit tests
```bash
make test
```

### e2e tests
Pre-requirement is to start the server (either locally or via Docker).

Then you can use:
```bash
# Run cypress tests locally.
make e2e

# Run cypress tests via their GUI (good for development and debugging).
make e2e-dev

# Run cypress via Docker like on CI.
make e2e-docker
```

### Helpful commands
#### Import of existing database
You need to have DB export `database.sql` present in project's directory.
```bash
make import
```

#### Database migration
```bash
mix ecto.migrate
```
