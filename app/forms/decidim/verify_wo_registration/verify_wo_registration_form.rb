# frozen_string_literal: true

module Decidim
  module VerifyWoRegistration
    # A form object used to wrap and validate params from the controller to the command.
    #
    class VerifyWoRegistrationForm < Form
      attribute :authorizations, Hash
      attribute :component_id, String
      attribute :redirect_url, String

      validates_presence_of :component_id, :redirect_url
      validate :verify_against_enabled_authorization_handlers

      # Returns authorization_handlers that were configured for the current component
      def authorization_handlers
        @authorization_handlers ||= begin
          ::Decidim::VerifyWoRegistration::ApplicationHelper.workflow_manifests(component).map do |workflow_manifest|
            Decidim::AuthorizationHandler.handler_for(workflow_manifest.name, handler_params(workflow_manifest.name))
          end
        end
      end

      # The authorizations from the params may be in the following format:
      #
      # ```
      # {"0"=>{"handler_name"=>"dummy_authorization_handler", "document_number"=>"00000000X", "postal_code"=>"00000", "birthday"=>"23/06/6"}}
      # ```
      #
      def handler_params(handler_name)
        authorization_params = authorizations
        return default_handler_params if authorization_params.nil?

        authorization_params = authorization_params.values.find { |h| h.with_indifferent_access[:handler_name] == handler_name }
        return default_handler_params if authorization_params.nil?

        authorization_params.merge(default_handler_params)
      end

      def default_handler_params
        { user: new_verified_user }
      end

      def new_verified_user
        @new_verified_user ||= Decidim::User.new(
          organization: current_organization,
          admin: false,
          managed: true,
          name: Time.current.utc.to_s(:number)
        ) do |u|
          u.nickname = UserBaseEntity.nicknamize(u.name, organization: current_organization)
          u.tos_agreement = true
          u.skip_confirmation!
        end
      end

      def component
        @component ||= begin
          c = Decidim::Component.find(component_id)
          raise ArgumentError unless c.participatory_space.organization.id == current_organization.id

          c
        end
      end

      # ----------------------------------------------------------------------
      private
      # ----------------------------------------------------------------------

      # Check if the data introduced by the user verifies against any handler enabled for the current component.
      def verify_against_enabled_authorization_handlers
        verifies_w_some_handler= authorization_handlers.any? {|handler| handler.valid? }

        errors.add(:authorizations, :invalid) unless verifies_w_some_handler
      end
    end
  end
end
