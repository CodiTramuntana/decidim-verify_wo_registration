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

        unless existing_verified_user?
          transaction do
            create_user
            create_authorizations
            update_user_extended_data
          end
        end

        broadcast(:ok, user)
      end

      private

      attr_reader :user

      def existing_verified_user?
        return unless @form.authorization_handlers.map.all? do |handler|
          handler.send(:duplicates).any?
        end

        @user = User
                .managed
                .where(organization: current_organization)
                .find_by("extended_data @> ?", { unique_id: @form.unique_id }.to_json)
      end

      def create_user
        @user= @form.authorization_handlers.first.user
        user.save!
      end

      def create_authorizations
        @form.authorization_handlers.each { |handler| Authorization.create_or_update_from(handler) }
      end

      def authorizations
        ::Decidim::Verifications::Authorizations.new(
          organization: current_organization,
          user: user,
          granted: true
        ).query
      end

      def update_user_extended_data
        user.update(
          extended_data: {
            component_id: @form.component_id,
            authorizations: authorizations.as_json(only: [:name, :granted_at, :metadata, :unique_id]),
            unique_id: unique_id,
            session_expired_at: 30.minutes.from_now
          }
        )
      end

      def unique_id
        authorizations.pluck(:unique_id).sort.join("-")
      end
    end
  end
end
