# CHANGELOG

All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/) and [Keep a Changelog](http://keepachangelog.com/).

## Unreleased

---

### New

### Changes

### Fixes

### Breaks

## 3.0.1 - (2023-08-17)

---

### Fixes

- Active View: nil is not a valid asset source issue in production app

## 3.0.0 - (2022-02-08)

---

### New

- Test integration with a Rails application without sprockets
- Add support for Rails 7.0 and Ruby 3.1

### Breaks

- Default to `public/assets/assets-manifest.json` manifest path matching new default from `webpack-assets-manifest` plugin
- Only support single manifest source file and error if not found (#9)
- Use `config.assets_manifest` as the config base to avoid conflicts in apps without sprockets (#9)
- Drop support for Ruby <2.7

## 2.1.2 - (2021-09-05)

---

### Fixes

- Return correct fully qualified URLs from manifest when relative URL host or asset host is configured

## 2.1.1 - (2021-06-20)

---

### Fixes

- Super method signature for keyword arguments

## 2.1.0 - (2019-09-11)

---

### New

- Automatically add `crossorigin="anonymous"` for SRI resources
- Separate manifest caching and eager loading

### Changes

- Remove defunct onboot manifest validation (f3fe8f57)

## 2.0.1 - (2019-08-09)

---

### Fixes

- Fix check if assets option node already exists

## 2.0.0 - (2019-08-08)

---

### New

- Accept glob patterns for `manifests` option

### Breaks

- Change `manifest` configuration option into `manifests` to support multiple files

## 1.1.0 - (2019-08-08)

---

### New

- Add passthrough option to load assets from other plugins (e.g. sprockets)

### Changes

- Only default to add available integrity if asset is from the manifest

## 1.0.0 - (2019-08-07)

---

### New

- Initial release
