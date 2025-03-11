# My Self-Hosted Setup
Currently running on a single raspberry pi. All that's required for deployment / management is SSH and docker-compose + docker.
Feel free to copy.

(Still very much a work in progress)

TODO: Log collection + integrating a log dashboard. \
TODO: Local CA implementation.

## Moving files to server
My recommendation is to use rsync but scp can also be utilised for file transfers over ssh.
Also use SSH keys, removes the hassle of password prompts + is safer if password auth is disabled after establising the keys.

**rsync example from this repo being the current working dir:**
```bash
rsync -avz --update ./* <user>@<your IP or hostname>:/opt/personal-hosting/

# eg.
rsync -avz --update ./* alanas@raspi.home:/opt/personal-hosting/
```

## Docker Compose Deployment

A convenient single command \
(Only safe assuming all persistent state is stored outside the containers.):
```bash
docker-compose up -d --force-recreate --build

# -d is for detachment from the current terminal session / daemonizing the containers.

# --force-recreate is to reinstanciate the containers so docker-compose.yml config is picked up.

# --build performs container image rebuilding to pick up Dockerfile changes.
```