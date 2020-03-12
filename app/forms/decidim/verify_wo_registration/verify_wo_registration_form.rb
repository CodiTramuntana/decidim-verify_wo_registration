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

      def authorization_handlers
        ::Decidim::VerifyWoRegistration::ApplicationHelper.workflow_manifests(component).map do |manifest|
          Decidim::AuthorizationHandler.handler_for(manifest.name, handler_params(manifest.name))
        end
      end

      def handler_params(handler_name)
        handler_params = authorizations
        return default_handler_params if handler_params.nil?

        handler_params = handler_params.values.find { |h| h["handler_name"] == handler_name }
        return default_handler_params if handler_params.nil?

        handler_params.merge(default_handler_params)
      end

      def default_handler_params
        { user: new_verified_user }
      end

      def new_verified_user
        @new_verified_user ||= Decidim::User.new(
          organization: current_organization,
          managed: true,
          name: Time.current.utc.to_s(:number)
        ) do |u|
          u.nickname = UserBaseEntity.nicknamize(u.name, organization: current_organization)
          u.admin = false
          u.roles = ["user_manager"] # Decidim::Admin::Permissions#user_manager?
          u.tos_agreement = true
        end
      end

      def component
        @component||= begin
          c= Decidim::Component.find(component_id)
          raise ArgumentError unless c.participatory_space.organization.id == current_organization.id
          c
        end
      end
    end
  end
end
