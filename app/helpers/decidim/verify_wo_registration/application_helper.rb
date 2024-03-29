# frozen_string_literal: true

module Decidim
  module VerifyWoRegistration
    # Custom helpers, scoped to the verify_wo_registration engine.
    #
    module ApplicationHelper
      def self.verify_wo_registration_custom_modal?(component)
        component.settings.try(:supports_without_registration) && all_verifications_of_type_direct?(component)
      end

      def self.workflow_manifests(component)
        return [] if component.permissions&.blank? || component.permissions.try(:fetch, "vote").blank?

        Decidim::Verifications::Adapter.from_collection(
          # component.permissions returns a structure of the form:
          # {"vote"=>{"authorization_handlers"=>{"dummy_authorization_handler"=>{"options"=>{"postal_code"=>"08001"}}}}}
          component.permissions['vote']['authorization_handlers'].keys
        )
      end

      # Checks whether all workflow manifests for the givevn +component+ are of type "direct".
      def self.all_verifications_of_type_direct?(component)
        manifests = workflow_manifests(component)
        manifests.any? && manifests.all? { |manifest| manifest.type == 'direct' }
      end
    end
  end
end
