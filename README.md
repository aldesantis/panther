# Panther

Panther is a lightweight, opinionated architecture for creating API-only Rails
applications.

It is heavily inspired by [Trailblazer](http://trailblazer.to/) but has a
gentler learning curve.

<!-- MarkdownTOC depth=3 autolink=true bracket=round -->

- [Installation](#installation)
- [Usage](#usage)
  - [Directory Structure](#directory-structure)
  - [Contracts](#contracts)
  - [Representers](#representers)
  - [Policies](#policies)
  - [Operations](#operations)
  - [Controllers](#controllers)
  - [Routes](#routes)
- [Contributing](#contributing)
- [License](#license)

<!-- /MarkdownTOC -->

## Installation

Add this line to your application's Gemfile:

```ruby gem 'panther' ```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install panther

## Usage

### Directory Structure

Let's see how we can implement a simple CRUD API for a Post resource.

Here's the directory structure we'll use:

```console
app/services/api/v1/post/
├── contract
│   ├── base.rb
│   ├── create.rb
│   └── update.rb
├── operation
│   ├── create.rb
│   ├── destroy.rb
│   ├── index.rb
│   ├── show.rb
│   └── update.rb
├── policy.rb
└── representer
    ├── collection.rb
    └── resource.rb
```

### Contracts

Contracts take incoming data, parse it and validate it.

Again, contracts are just [Reform](https://github.com/apotonick/reform) forms.

```ruby
# app/services/api/v1/post/contract/base.rb
module API
  module V1
    module Post
      module Contract
        class Base < ::Panther::Contract::Base
          property :user_id, writable: false
          property :title, type: Coercible::String
          property :body, type: Coercible::String

          validates :title, presence: true
          validates :body, presence: true
        end
      end
    end
  end
end

# app/services/api/v1/post/contract/create.rb
module API
  module V1
    module Post
      module Contract
        class Create < Base
        end
      end
    end
  end
end

# app/services/api/v1/post/contract/create.rb
module API
  module V1
    module Post
      module Contract
        class Update < Base
          property :title, writable: false
        end
      end
    end
  end
end
```

We have defined the `title` property as read-only in the `Update` contract. That
means the title of a post can't be changed once a post is created.

We have also defined an unwritable `user_id` property that will be used by the
resource's policy to ensure the user is authorized to update/destroy a post.

### Representers

A representer's job is to render a resource in a specific format. Panther
assumes you'll use JSON, but XML and other formats will work fine.

Representers are nothing more than [Roar](https://github.com/apotonick/roar)
decorators with some assumptions, so you can tweak them as you see fit.

Panther also provides mixins for representing collection and pagination data.

```ruby
# app/services/api/v1/post/representer/collection.rb
module API
  module V1
    module Post
      module Representer
        class Collection < ::Panther::Representer::Base
          include ::Panther::Representer::Collection
          include ::Panther::Representer::Pagination
        end
      end
    end
  end
end

# app/services/api/v1/post/representer/resource.rb
module API
  module V1
    module Post
      module Representer
        class Resource < ::Panther::Representer::Base
          property :id
          property :title
          property :body
        end
      end
    end
  end
end
```

### Policies

Policies are POROs. They take a contract (or a model, if a contract is not
needed) and a user object as input, and provide a set of predicates to determine
whether the user is authorized to perform the given action on the resource.

They are inspired by [Pundit](https://github.com/elabs/pundit) policies, but
I didn't need any of Pundit's features, so I just reimplemented them from
scratch.

```ruby
# app/services/api/v1/post/policy.rb
module API
  module V1
    module Post
      class Policy < ::Panther::Policy::Base
        def show?
          true
        end

        def create?
          true
        end

        def update?
          post_belongs_to_user?
        end

        def destroy?
          post_belongs_to_user?
        end

        private

        def post_belongs_to_user?
          model.user_id.present? && model.user_id == user.id
        end
      end
    end
  end
end
```

The `#model` method returns the contract (for create and update operations) or
record (for show and destroy operations) that is being operated on, while the
`#user` method returns the `current_user` parameter that was passed to the
operation.

### Operations

Operations glue representers, contracts and policies together to perform tasks
on a certain resource.

Panther provides default implementations for CRUD operations. The default
operations make the following assumptions about the resources:

- They have a policy with methods for all supported actions
- They have both a `Resource` and a `Collection` representer
- They have a contract for the `Create` and `Update` actions (if supported)

Of course, you're free to write your own custom CRUD operations. You can also
write non-CRUD operations, although that's usually a sign something's wrong with
your API architecture.

If you want, you can take a look at the [default operations](https://github.com/alessandro1997/panther/tree/master/lib/panther/operation)
to see how Panther works under the hood and how you can implement your own
operations.

```ruby
# app/services/api/v1/post/operation/index.rb
module API
  module V1
    module Post
      module Operation
        class Index < ::Panther::Operation::Index
        end
      end
    end
  end
end

# app/services/api/v1/post/operation/show.rb
module API
  module V1
    module Post
      module Operation
        class Show < ::Panther::Operation::Show
        end
      end
    end
  end
end


# app/services/api/v1/post/operation/create.rb
module API
  module V1
    module Post
      module Operation
        class Create < ::Panther::Operation::Create
          private

          def build_resource(params)
            ::Post.new(user: params[:current_user])
          end
        end
      end
    end
  end
end

# app/services/api/v1/post/operation/update.rb
module API
  module V1
    module Post
      module Operation
        class Update < ::Panther::Operation::Update
        end
      end
    end
  end
end

# app/services/api/v1/post/operation/destroy.rb
module API
  module V1
    module Post
      module Operation
        class Destroy < ::Panther::Operation::Destroy
        end
      end
    end
  end
end
```

### Controllers

Panther provides a module that can be included into a controller to expose a
resource's operations:

```ruby
# app/controllers/api/v1/posts_controller.rb
module API
  module V1
    class PostsController < ApplicationController
      include Panther::Controller

      actions :index, :show, :create, :update, :destroy

      private

      def operation_params
        params.merge(current_user: current_user)
      end
    end
  end
end
```

In addition to the parameters provided by the API's consumer, we also pass the
`current_user` parameter to the operation. It will be used by the policy to
authorize the user's actions.

Note that Panther makes no distinction between parameters passed by the consumer
(that will usually be the `params` hash in Rails) and parameters passed by the
developer, so you should ensure that there are no conflicting names and that
any internal parameters overwrite the user-defined ones. This is part of
Panther's design and will not change.

### Routes

All that's left now is to route to our operations:

```ruby
# config/routes.rb
Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :posts, only: %i(index show create update destroy)
    end
  end
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/alessandro1997/panther.

## License

The gem is available as open source under the terms of the
[MIT License](http://opensource.org/licenses/MIT).
