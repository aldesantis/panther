# Panther

Panther is a lightweight, opinionated architecture for creating API-only Rails
applications.

It is heavily inspired by [Trailblazer](http://trailblazer.to/) but has a
gentler learning curve.

## Installation

Add this line to your application's Gemfile:

```ruby gem 'panther' ```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install panther

## Concepts

Panther revolves around four core concepts: the contract, the operation, the
policy and the representer.

### Representer

A representer's job is to render a resource in a specific format. Panther
assumes you'll use JSON, but XML and other formats will work fine.

Representers are nothing more than [Roar](https://github.com/apotonick/roar)
decorators with some assumptions, so you can tweak them as you see fit.

Panther also provides you with mixins for representing collection and pagination
data.

Here's what a representer looks like:

```ruby
class UploadRepresenter < Panther::Representer::Base
  property :id
  property :user_id
  property :purpose
  property :file_url
  property :metadata, exec_context: :decorator
  property :created_at, exec_context: :decorator

  def metadata
    represented.file.metadata
  end

  def created_at
    represented.created_at.to_i
  end
end
```

### Contract

Contracts take incoming data, parse it and validate it.

Again, contracts are just [Reform](https://github.com/apotonick/reform) forms.

Here's what a contract looks like:

```ruby
class CreateLinkContract < Panther::Contract::Base
  property :user_id, type: Coercible::Int
  property :url, type: Coercible::String

  validates :user_id, presence: true
  validates :url, presence: true
end
```

### Policy

Policies are POROs. They take a contract (or a model, if a contract is not
needed) and a user object as input, and provide a set of predicates to determine
whether the user is authorized to perform the given action on the resource.

They are inspired to [Pundit](https://github.com/elabs/pundit) policies, but
I didn't need any of Pundit's features, so I just reimplemented them from
scratch.

Here's what a policy looks like:

```ruby
class UploadPolicy < Panther::Policy::Base
  def show?
    upload_belongs_to_user?
  end

  def create?
    upload_belongs_to_user?
  end

  def update?
    upload_belongs_to_user?
  end

  def destroy?
    upload_belongs_to_user?
  end

  private

  def upload_belongs_to_user?
    model.user_id.present? && model.user_id.to_i == user.id
  end
end
```

### Operation

Operations glue representers, contracts and policies together to perform tasks
on a certain resource.

Panther provides you with a set of default CRUD operations, but you're free to
write your own.

Here's what an operation looks like:

```ruby
class CreateUserOperation < Panther::Operation::Base
  def run(params)
    user = User.new
    contract = CreateUserContract.new(user)

    authorize_and_validate contract: contract, params: params

    contract.save

    UserRepresenter.new(user)
  end
end
```

## Usage

TODO: Write usage instructions

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/alessandro1997/panther.


## License

The gem is available as open source under the terms of the
[MIT License](http://opensource.org/licenses/MIT).
