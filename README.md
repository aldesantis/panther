# Panther

[![Build Status](https://img.shields.io/travis/alessandro1997/panther.svg?maxAge=3600&style=flat-square)](https://travis-ci.org/alessandro1997/panther)
[![Dependency Status](https://img.shields.io/gemnasium/alessandro1997/panther.svg?maxAge=3600&style=flat-square)](https://gemnasium.com/github.com/alessandro1997/panther)
[![Code Climate](https://img.shields.io/codeclimate/github/alessandro1997/panther.svg?maxAge=3600&style=flat-square)](https://codeclimate.com/github/alessandro1997/panther)

Panther is a lightweight, opinionated architecture for creating API-only Rails applications.

It is heavily inspired by [Trailblazer](http://trailblazer.to/) but is _much_ more opinionated and
has a gentler learning curve.

- [API Documentation](http://www.rubydoc.info/github/alessandro1997/panther/master)

## Installation

Add this line to your application's Gemfile:

```ruby gem 'panther' ```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install panther

## Usage

TODO: Write usage instructions

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/alessandro1997/panther.

## License

The gem is available as open source under the terms of the
[MIT License](http://opensource.org/licenses/MIT).

## To-dos

- [ ] Write API documentation.
- [ ] Write user guides.
- [ ] Write tests.
- [x] Don't include `Dry::Types` directly into `Contract::Base`.
- [x] Only expose existing attributes in `Representer::Timestamped`.
- [ ] Use a stable version of ROAR.
- [ ] Provide a way for operations to inherit callbacks.
- [ ] Provide a way to configure pagination in the `Index` operation.
- [ ] Discover supported operations automatically in `Panther::Controller`.
- [ ] Support Kaminari as well as will_paginate in `Representer::Sideload`.
- [ ] Allow providing the `per_page` option in `Representer::Sideload`.
- [ ] Allow nesting the `include` option in `Representer::Sideload`.
- [ ] Add `expose_id` option to `Representer::Sideload`.
