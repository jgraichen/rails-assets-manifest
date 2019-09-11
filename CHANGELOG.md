# CHANGELOG

All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/) and [Keep a Changelog](http://keepachangelog.com/).



## Unreleased
---

### New

### Changes

### Fixes

### Breaks


## 2.1.0 - (2019-09-11)
---

### New
* Automatically add `crossorigin="anonymous"` for SRI resources
* Separate manifest caching and eager loading

### Changes
* Remove defunct onboot manifest validation (f3fe8f57)


## 2.0.1 - (2019-08-09)
---

### Fixes
* Fix check if assets option node already exists


## 2.0.0 - (2019-08-08)
---

### New
* Accept glob patterns for `manifests` option


### Breaks
* Change `manifest` configuration option into `manifests` to support multiple files


## 1.1.0 - (2019-08-08)
---

### New
* Add passthrough option to load assets from other plugins (e.g. sprockets)

### Changes
* Only default to add available integrity if asset is from the manifest


## 1.0.0 - (2019-08-07)
---

### New
* Initial release


