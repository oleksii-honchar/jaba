# JABA

Javascript Application BAse docker

# Purpose
To optimize local & production build 2 different docker images used with node.js and build tools pre-installed.

# Install
I'm using npm script to execute command and ave node-js always installe don my laptop. So, ecude me to firce you to use npm also for such simple things )

You gonna need node.js so, install [nvm](https://github.com/nvm-sh/nvm) first. Then install node@12 and finally [yarn](https://yarnpkg.com/lang/en/docs/install/#mac-stable):

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash
nvm install 12
nvm alias default 12
curl -o- -L https://yarnpkg.com/install.sh | bash
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
