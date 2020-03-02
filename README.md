# Decidim::VerifyWoRegistration

Adds the hability for proposals and budgets components to allow users to give support without being registered. Enabling this feature the user is requested for verification and then, on success, logged in in a 30min session..

## Usage

VerifyWoRegistration will be available as a Component for a Participatory
Space.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'decidim-verify_wo_registration
```

And then execute:

```bash
bundle
```

### Run tests

Create a dummy app in your application (if not present):

```bash
bin/rails decidim:generate_external_test_app
cd spec/decidim_dummy_app/
bundle exec rails decidim_department_admin:install:migrations
RAILS_ENV=test bundle exec rails db:migrate
```

Edit dummy_app's `config/application.rb` file to enforce railties ordering:
```ruby
module DecidimDepartmentAdminTestApp
  class Application < Rails::Application

...
    config.railties_order = [Decidim::Core::Engine, Decidim::DepartmentAdmin::Engine, :main_app, :all]
...

  end
end
```

And run tests:

```bash
bundle exec rspec spec
```

## Contributing

See [Decidim](https://github.com/decidim/decidim).

## License

This engine is distributed under the GNU AFFERO GENERAL PUBLIC LICENSE.
