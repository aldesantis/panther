# Panther

[![Dependency Status](https://gemnasium.com/badges/github.com/alessandro1997/panther.svg)](https://gemnasium.com/github.com/alessandro1997/panther)
[![Code Climate](https://codeclimate.com/github/alessandro1997/panther/badges/gpa.svg)](https://codeclimate.com/github/alessandro1997/panther)

Panther is a lightweight, opinionated architecture for creating API-only Rails applications.

It is heavily inspired by [Trailblazer](http://trailblazer.to/) but is _much_ more opinionated and
has a gentler learning curve.

<!-- MarkdownTOC depth=3 autolink=true bracket=round -->

- [Installation](#installation)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)
- [To-dos](#to-dos)

<!-- /MarkdownTOC -->

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
