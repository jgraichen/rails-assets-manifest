# Rails::Assets::Manifest

Load all assets in your rails application from a `manifest.json`, e.g. generated by [webpack-assets-manifest](https://github.com/webdeveric/webpack-assets-manifest).

The Manifest must either be a simple string map or must map to objects having a `'src'` attribute. Subresource integrity is supported.

```json
{
  "application.css": {
    "src": "2b16adf6f756625a0194.css",
    "integrity": "sha384-/oreyvcV6U6htGZD0fDWR8/Txezke8KhD0QNgHb660hSaW7M+ZzxxuB4Vo+PuAC9"
  },
  "application.js": {
    "src": "2b16adf6f756625a0194.js",
    "integrity": "sha384-iJ55fQQApbQGxWEWSbWStBabi+yNGxZSQy/010+1Dhxl+rymyhGF4NtjUkOsYv7B"
  }
}
```

This gem does not add new helper methods but extends the existing helpers. SRI is automatically added if available and within a secure context:

```slim
html
  head
    = stylesheet_link_tag 'application', media: 'all'
    = javascript_include_tag 'application'
```

```html
<link rel="stylesheet" media="all" href="2b16adf6f756625a0194.css" integrity="sha384-/oreyvcV6U6htGZD0fDWR8/Txezke8KhD0QNgHb660hSaW7M+ZzxxuB4Vo+PuAC9" type="stylesheet">
<script src="2b16adf6f756625a0194.js" integrity="sha384-iJ55fQQApbQGxWEWSbWStBabi+yNGxZSQy/010+1Dhxl+rymyhGF4NtjUkOsYv7B" type="javascript"></script>
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rails-assets-manifest'
```

## Usage

TODO

## Contributing

1. [Fork it](http://github.com/jgraichen/rails-assets-manifest/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit specs for your feature so that I do not break it later
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request

## MIT License

Copyright (c) 2018 Jan Graichen

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
