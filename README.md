# Pundit::Before

![CI](https://github.com/javierav/pundit-before/workflows/CI/badge.svg)

Adds `before` hook to pundit policy classes to resolve things like varvet/pundit#474. Inspired by action_policy
[pre-checks](https://actionpolicy.evilmartians.io/#/pre_checks).

## Installation

Add this line to your application's Gemfile:

```ruby
gem "pundit-before"
```

And then execute:

```shell
bundle install
```

## Usage

Use `allow!` inside callback method or block to return `true` without evaluating `edit?` method defined in policy.

```ruby
class UserPolicy < ApplicationPolicy
  include Pundit::Before

  before :check_admin

  def edit?
    false
  end

  private

  def check_admin
    allow! if user.admin?
  end
end

UserPolicy.new(User.new(admin: true), record).edit?  # => true
UserPolicy.new(User.new(admin: false), record).edit? # => false
```

Use `deny!` inside callback method or block to return `false` without evaluating `edit?` method defined in policy.

```ruby
class UserPolicy < ApplicationPolicy
  include Pundit::Before

  before :check_admin

  def edit?
    true
  end

  private

  def check_admin
    deny! unless user.admin?
  end
end

UserPolicy.new(User.new(admin: true), record).edit?  # => true
UserPolicy.new(User.new(admin: false), record).edit? # => false
```

Internally `before` hook is implemented as `ActiveSupport::Callbacks`, so the callback chain will halt if do any call to
`allow!` or `deny!` method. It's similar as Rails controller action filters works.

### block form

```ruby
class UserPolicy < ApplicationPolicy
  include Pundit::Before

  before do
    allow! if user.admin?
  end

  def edit?
    false
  end
end
```

### skip before hook

```ruby
class UserPolicy < ApplicationPolicy
  include Pundit::Before

  before :check_admin

  def edit?
    false
  end

  private

  def check_admin
    allow! if user.admin?
  end
end

class OperatorPolicy < UserPolicy
  skip_before :check_admin
end

UserPolicy.new(User.new(admin: true), record).edit?     # => true
OperatorPolicy.new(User.new(admin: true), record).edit? # => false
```

### using `only` modifier

```ruby
class UserPolicy < ApplicationPolicy
  include Pundit::Before

  before :check_admin, only: :update?

  def edit?
    false
  end

  private

  def check_admin
    allow! if user.admin?
  end
end

UserPolicy.new(User.new(admin: true), record).edit? # => false
```

### using `except` modifier

```ruby
class UserPolicy < ApplicationPolicy
  include Pundit::Before

  before :check_admin, except: :edit?

  def edit?
    false
  end

  def destroy?
    false
  end

  private

  def check_admin
    allow! if user.admin?
  end
end

UserPolicy.new(User.new(admin: true), record).edit?    # => false
UserPolicy.new(User.new(admin: true), record).destroy? # => true
```

### calling multiple methods

```ruby
class UserPolicy < BasePolicy
  before :check_presence, :check_admin

  def edit?
    false
  end

  private

  def check_presence
    deny! unless user.present?
  end

  def check_admin
    allow! if user.admin?
  end
end

UserPolicy.new(nil, record).edit?                    # => false
UserPolicy.new(User.new(admin: false), record).edit? # => false
UserPolicy.new(User.new(admin: true), record).edit?  # => true
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests.
You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bin/rake install`.

To release a new version, update the version number in `version.rb`, and then run `bin/rake release`,
which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## License

Copyright © 2023 Javier Aranda. Released under the terms of the [MIT license](LICENSE).
