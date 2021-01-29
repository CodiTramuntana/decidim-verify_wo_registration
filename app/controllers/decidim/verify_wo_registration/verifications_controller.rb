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
        @form = form(VerifyWoRegistrationForm).from_params(params)
      end

      def create
        @form = form(VerifyWoRegistrationForm).from_params(form_params)

        DoVerifyWoRegistration.call(@form) do
          on(:ok) do |user|
            flash[:notice] = I18n.t('verify_wo_registration.create.success', minutes: ::Decidim::ImpersonationLog::SESSION_TIME_IN_MINUTES)

            sign_in(user)
            redirect_to @form.redirect_url
          end

          on(:use_registered_user) do
            flash.now[:alert] = I18n.t('verify_wo_registration.create.use_registered_user')
            render :new
          end

          on(:invalid) do
            flash.now[:alert] = I18n.t('impersonations.create.error', scope: 'decidim.admin')
            render :new
          end
        end
      end

      # -------------------------------------------------------------
      private
      # -------------------------------------------------------------

      def form_params
        {
          authorizations: verify_params[:authorizations],
          component_id: component.id,
          redirect_url: verify_params[:redirect_url]
        }
      end

      def verify_params
        params[:verify_wo_registration].permit!
      end

      def component
        @component ||= Decidim::Component.find(params[:component_id] || verify_params[:component_id])
      end

      # Should we validate that only 'direct' verification handlers are enabled?
      def validate_verification_workflow_manifests!
        return if Decidim::VerifyWoRegistration::ApplicationHelper.verify_wo_registration_custom_modal?(component)

        raise 'Invalid verifications, all verifications should be of type direct'
      end
    end
  end
end
