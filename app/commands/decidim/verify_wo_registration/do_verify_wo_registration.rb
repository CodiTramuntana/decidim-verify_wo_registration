# frozen_string_literal: true

module Decidim
  module VerifyWoRegistration
    # A command with all the business logic to verify and impersonate (managed user).
    class DoVerifyWoRegistration < Rectify::Command
      # Public: Initializes the command.
      #
      # form         - The form with the authorization info
      def initialize(form)
        @form = form
      end

      # Executes the command. Broadcasts this events:
      #
      # - :ok when everything is valid.
      # - :invalid if the form is not valid.
      #
      # Returns nothing.
      def call
        if authorizations_exists?
          if existing_registered_user?
            # ignore form data, make the participant use the already existing user
            broadcast(:use_registered_user)
          elsif existing_impersonated_user?
            # we can not reuse existing authorization because it will raise "A participant is already authorized with the same data." on @form.valid?
            # as it is an impersonated user, we can safely destroy it and perform the verification process again
            transaction do
              destroy_authorization
              if @form.valid?
                authorize_user
                broadcast(:ok, user)
              else
                broadcast(:invalid)
              end
            end
          else
            Rails.logger.warn('This should never happen :(')
            broadcast(:invalid)
          end
        elsif @form.valid?
          transaction do
            create_user
            authorize_user
          end
          broadcast(:ok, user)
        else
          broadcast(:invalid)
        end
      end

      #----------------------------------------------------------------------
      private
      #----------------------------------------------------------------------

      attr_reader :user, :form

      # Searches for a registered (not managed) user associated with the given form authorizations.
      def existing_registered_user?
        @user = @authorization.user unless @authorization.user.managed?
      end

      # Searches for an authentication user associated to the given form authorizations
      # The user should BE managed.
      def existing_impersonated_user?
        if @authorization.user.managed?
          @user = @authorization.user
          user.skip_confirmation!
        end
      end

      # Some authentication already exists?
      # Sets the first found authorization to +@authorization+ attribute.
      def authorizations_exists?
        @form.authorization_handlers.any? do |handler|
          @authorization = Authorization.joins(:user).where('decidim_users.decidim_organization_id = ?', form.current_organization).where(
            name: handler.handler_name,
            unique_id: handler.unique_id
          ).first
        end
      end

      def destroy_authorization
        @authorization.destroy
      end

      def authorize_user
        transaction do
          create_or_update_authorization
          update_user_extended_data
        end
      end

      def create_user
        @user = @form.authorization_handlers.first.user
        user.save!
      end

      def create_or_update_authorization
        handler= @form.verified_handler
        handler.user = user
        Authorization.create_or_update_from(handler)
      end

      def user_authorizations
        ::Decidim::Verifications::Authorizations.new(
          organization: form.current_organization,
          user: user,
          granted: true
        ).query
      end

      def update_user_extended_data
        user.update(
          extended_data: {
            component_id: @form.component_id,
            authorizations: user_authorizations.as_json(only: %i[name granted_at metadata unique_id]),
            unique_id: unique_id,
            session_expired_at: 30.minutes.from_now
          }
        )
      end

      def unique_id
        user_authorizations.pluck(:unique_id).sort.join('-')
      end
    end
  end
end
