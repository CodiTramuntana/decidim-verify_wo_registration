# Decidim::VerifyWoRegistration

Adds the hability for proposals and budgets components to allow users to give support without being registered. Enabling this feature the user is requested for verification and then, on success, logged in into a 30min session.

The current behavior is as follows. When the logged out user arrives to an action that requires verifiaction the popup offers a new option to allow the user to open a temporal session without the need to signup to the platform. Once selected the form for the first direct verifier found is rendered to the user to fill it.
On submit, first checks if there's already an authorization for the first direct verifier. If an authorization exists, redirects back and tells the user to use the already verified account, if not, then tries to verify the user with the current data in the form.
A special case are impersonated (managed) users that are re-authenticated every time.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'decidim-verify_wo_registration'
```

And then execute:

```bash
bundle install
```

## Usage

This module allows admins to enable participants to open sessions from Proposals and Budgets components (login in) without being registered.

For this feature to be enabled admins should do two things:

- navigate to the corresponding component, select the "Enable supports without registration (user only verifies)" ("Poder donar suports sense registre (només verificant-se)") check and save.
- navigate to this component's permissions, and select a direct verifier for some of its actions. Note that multi-step verifiers are not supported.

This will enable the feature in the public views.

Once enabled, non registered (thus not logged in) participants will have to navigate to the given component (a proposal or a budget) and click in the support/vote/select project action. The login modal now will have a new "I have no user and I do not want to" button that takes the participant to a verification screen. Once the user is correctly verified, a 30min session starts for her to participate.

Note that although the only way for participants to open a session is by clicking the "Support" button, once verified, she will be able to perform all the actions that require the authentications she has verified for.

### Warning

Platform administrators should take care not to reset authorizations while in the middle of a process.
Reseting verifications will remove `Authorization`s from existing impersonated users. This will allow participants to vote again in the same process with the same credentials via this module or being "manually" impersonated.

## Run tests

Create a dummy app in your application (if not present):

```bash
bin/rails decidim:generate_external_test_app
cd spec/decidim_dummy_app/
bundle exec rails decidim-verify_wo_registration:install:migrations
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
