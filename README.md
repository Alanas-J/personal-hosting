# My Self-Hosted Setup
Currently running on a single raspberry pi. All that's required for deployment / management is SSH and docker-compose + docker.
Feel free to copy.

Currently featuring:
- Traefik for convenient proxy management.
- Grafana (with Loki, Prometheus and Alloy) for log and metric observability.
- Pihole to act as the local DNS (and as a pihole).


## Moving files to server
My recommendation is to use rsync but scp can also be utilised for file transfers over ssh.
Also use SSH keys, removes the hassle of password prompts + is safer if password auth is disabled after establising the keys.

**rsync example from this repo being the current working dir:**
```bash
rsync -avz --update ./* <user>@<your IP or hostname>:/opt/personal-hosting/

# eg.
rsync -avz --update ./* alanas@raspi.home:/opt/personal-hosting/
# Or if using SSH agent something like.
eval "$(ssh-agent -s)" 
rsync -avz --update ./* raspi:/opt/personal-hosting/
```

## Docker Compose Deployment
Restarts and on boot start is handled by Docker itself (Linux docker installs add docker to systemd or equivalent).

To load the stack for the first time you only need a single command
```bash
docker-compose -f services.docker-compose.yml -f grafana.docker-compose.yml -f core.docker-compose.yml up -d --force-recreate --build

# -d is for detachment from the current terminal session / daemonizing the containers.

# --force-recreate is to reinstanciate the containers so docker-compose.yml config is picked up.

# --build performs container image rebuilding to pick up Dockerfile changes.

# Order of -f file arguments matter, they merge ontop of eachother. 
# core.docker-compose.yml must be last as it defines the network interfaces.
```

Afterward you can just supply individual docker-compose files to update pieces of the stack.