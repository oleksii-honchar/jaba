# JABA

Javascript Application BAse dockers

## Purpose

To optimize local & production build 3 different docker images used with node.js and build tools pre-installed:

- build - includes build-essentials
- node - node(alpine) + bash
- static - alpine + bash for static only

## Install


## Build & push

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
