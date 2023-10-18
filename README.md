# JABA

Javascript Application BAse dockers

## Purpose

To optimize local & production build 3 different docker images used with node.js and build tools pre-installed:

- build - includes build-essentials
- node - node(alpine) + bash
- static - alpine + bash for static only

## Build & push

```bash
make build-all
make push-all

```