# frozen_string_literal: true

module Decidim
  module VerifyWoRegistration
    # A form object used to "impersonate" users from the public front end.
    #
    # This form will contain a dynamic attribute for the user authorization.
    # This authorization will be selected by the admin user if more than one exists.
    class VerifyWoRegistrationForm < Form
      attribute :authorizations, Array[Object]
      attribute :component_id, String
      attribute :redirect_url, String
      attribute :votable_gid, String

      validates_presence_of :authorizations, :component_id, :redirect_url, :votable_gid

      def unique_id
        authorizations.pluck(:unique_id).sort.join("-")
      end
    end
  end
end
