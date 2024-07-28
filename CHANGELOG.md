# Changelog

## [1.1.0](https://github.com/oleksii-honchar/jaba/compare/v1.0.0...v1.1.0) (2024-07-28)


### Features

* add release please and build-n-push ([#7](https://github.com/oleksii-honchar/jaba/issues/7)) ([d720f47](https://github.com/oleksii-honchar/jaba/commit/d720f470f081bc38ebee278b2805426f31faf26d))
* bump node.js version ([298ee91](https://github.com/oleksii-honchar/jaba/commit/298ee91154c78425e54b299412d1e984fc017a62))
* major update after years in limbo ([494e81f](https://github.com/oleksii-honchar/jaba/commit/494e81fa94aa6b804227bf1c6ee2088a525d44c9))
* prod image -&gt; node:12-alpine in order to run node scripts ([56656a1](https://github.com/oleksii-honchar/jaba/commit/56656a19dd8c581670affef3db044c0a9e852690))
* redirect for custom path host:port/path ([c13c8fa](https://github.com/oleksii-honchar/jaba/commit/c13c8fab6f82b30555c94d0ad9d142e38e318a00))
* switch to build/node/static images ([bcd117a](https://github.com/oleksii-honchar/jaba/commit/bcd117a0b5188eafbb7adfdcebc6e362c8d919e4))
* updated docker for latest relevant config; used nginx-more for static base; rewrote script to makefile ([1aac0af](https://github.com/oleksii-honchar/jaba/commit/1aac0af52d0c53d42abee1d888c71427df31b64b))


### Bug Fixes

* project.env refs ([20f7a80](https://github.com/oleksii-honchar/jaba/commit/20f7a80cba8f2bf3e9a9e416656734c5ea4c72e1))

## 22.3-1

- add multi-platform build

## 22.3-0

- bump `node.js` to `v22.3`
- changed versioning to follow `node.js` versions

## 3.0.5

- `jaba-build` and `jaba-node` docker image user home changed to `usr/scr/app`
- `nginx-more` update to 1.27.0-0
