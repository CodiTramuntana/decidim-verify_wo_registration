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
        return broadcast(:invalid) unless @form.valid?

        if authorizations_exists?
          if existing_registered_user?
            broadcast(:use_registered_user)
          elsif existing_impersonated_user?
            authorize_user
            broadcast(:ok, user)
          else
            Rails.logger.warn('This should never happen :(')
            broadcast(:invalid)
          end
        else
          transaction do
            create_user
            authorize_user
          end
          broadcast(:ok, user)
        end
      end

      private

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
      # Saves the first found authorization to +@authorization+ attribute.
      def authorizations_exists?
        @form.authorization_handlers.any? do |handler|
          @authorization = Authorization.joins(:user).where('decidim_users.decidim_organization_id = ?', form.current_organization).where(
            name: handler.handler_name,
            unique_id: handler.unique_id
          ).first
        end
      end

      def authorize_user
        transaction do
          create_or_update_authorizations
          update_user_extended_data
        end
      end

      def create_user
        @user = @form.authorization_handlers.first.user
        user.save!
      end

      def create_or_update_authorizations
        @form.authorization_handlers.each do |handler|
          handler.user = user
          Authorization.create_or_update_from(handler)
        end
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
