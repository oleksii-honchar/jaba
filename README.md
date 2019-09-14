# JABA

Javascript Application BAse docker

# Purpose
To optimize local & production build 3 different docker images used with node.js and build tools pre-installed:

- build - includes build-essentials
- node - node(alpine) + bash
- static - alpine + bash for static only

# Install
I'm using npm script to execute command and have node-js always installed on my laptop. So, excuse me to force you to use npm also for such simple things )

You gonna need node.js so, install [nvm](https://github.com/nvm-sh/nvm) first. Then install node@12 and finally [yarn](https://yarnpkg.com/lang/en/docs/install/#mac-stable). Finally you need `jq` for json manipulations:

```bash
#nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash
nvm install 12
nvm alias default 12

# yarn
curl -o- -L https://yarnpkg.com/install.sh | bash

#jq
brew install jq
```

# Build & push

Using npm scripts:
```bash
yarn docker:build
yarn docker:push
```

Or, you can just run script manually (not recommended):
```bash
./scripts/build.sh
./devops/docker/scripts/push-image.sh
./devops/docker/scripts/push-latest-image.sh
```
