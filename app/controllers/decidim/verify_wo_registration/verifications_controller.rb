# frozen_string_literal: true

module Decidim
  module VerifyWoRegistration
    class VerificationsController < Decidim::ApplicationController
      include ::Devise::Controllers::Helpers
      include ::Decidim::VerifyWoRegistration::ApplicationHelper
      include FormFactory

      before_action :validate_verification_workflow_manifests!

      helper Decidim::AuthorizationFormHelper

      def new
        @form = form(VerifyWoRegistrationForm).from_params(form_params)
      end

      def create
        @form = form(VerifyWoRegistrationForm).from_params(form_params)

        OnlyVerifiedVote.call(@form) do
          on(:ok) do |user|
            flash[:notice] = I18n.t("impersonations.create.success", scope: "decidim.admin")
            sign_in(user)
            redirect_to @form.redirect_url
          end

          on(:invalid) do
            flash.now[:alert] = I18n.t("impersonations.create.error", scope: "decidim.admin")
            render :new
          end
        end
      end

      private

      def form_params
        {
          authorizations: authorization_handlers,
          component_id: component.id,
          redirect_url: params[:redirect_url] || params[:only_verified_votes][:redirect_url],
          votable_gid: params[:votable_gid] || params[:only_verified_votes][:votable_gid]
        }
      end

      def new_only_verified_user
        @new_only_verified_user ||= Decidim::User.new(
          organization: current_organization,
          managed: true,
          name: Time.now.utc.to_s(:number)
        ) do |u|
          u.nickname = UserBaseEntity.nicknamize(u.name, organization: current_organization)
          u.admin = false
          u.roles = ["user_manager"] # Decidim::Admin::Permissions#user_manager?
          u.tos_agreement = true
        end
      end

      def authorization_handlers
        workflow_manifests(component).map do |manifest|
          Decidim::AuthorizationHandler.handler_for(manifest.name, handler_params(manifest.name))
        end
      end

      def handler_params(handler_name)
        handler_params = params.dig(:only_verified_votes, :authorizations)
        return default_handler_params if handler_params.nil?

        handler_params = handler_params.values.find { |h| h["handler_name"] == handler_name }
        return default_handler_params if handler_params.nil?

        handler_params.merge(default_handler_params)
      end

      def default_handler_params
        { user: new_only_verified_user }
      end

      def component
        @component ||= Decidim::Component.find(params[:component_id] || params[:only_verified_votes][:component_id])
      end

      # Should we validate that only 'direct' verification handlers are enabled?
      def validate_verification_workflow_manifests!
        return if all_verifications_of_type_direct?(component)

        raise "Invalid verifications, all verifications should be of type direct"
      end
    end
  end
end
