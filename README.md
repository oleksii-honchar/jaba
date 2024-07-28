# JABA

**J**avascript **A**pplication **BA**se dockers

## Purpose

To have defined base images for the following scenarios:

- `jaba-build` - build JS/TS project
- `jaba-static` - serve static content ([usage example](https://github.com/oleksii-honchar/ts-react-tmpl))
- `jaba-node` - execute pre-build node.js application

## How to build

```shell
make build-all
make tag-latest-all
make push-all
```

## How to use

Use `tuiteraz/jaba-<type>` as base image in your `Dockefile`

Also `jaba-static` available for local testing:

```shell
make up type=static
# open in browser localhost:8100
make down type=static
```

## How to deploy manually

- before commit/merge changes to `main`, bump `latest-version.txt` version and describe changes in `CHANGELOG.md`
- commit/merge changes to main
- create tag = `latest-version.txt`, e.g. `v0.3.0`
- `git push --tags`
- build & push image: `make build-n-push-all`
