# frozen_string_literal: true

require "spec_helper"

describe Decidim::VerifyWoRegistration::VerificationsController, type: :controller do
  routes { Decidim::VerifyWoRegistration::Engine.routes }

  let(:organization) { component.organization }

  before do
    request.env["decidim.current_organization"] = organization
    request.env["decidim.current_participatory_space"] = component.participatory_space
    request.env["decidim.current_component"] = component
  end

  describe 'Proposals component with supports_without_registration DISabled' do
    include_examples 'has a proposal ready to vote'
    include_examples 'the component has supports_without_registration enabled'

    before do
      component.attributes['settings']['global']['supports_without_registration'] = false
      component.save!
    end

    it "does not render the form" do
      expect {
        get(:new, params: {verify_wo_registration: {component_id: component.id}})
      }.to raise_exception('Invalid verifications, all verifications should be of type direct')
    end

    it "does not accept POST requests" do
      expect {
        post :create, params: {verify_wo_registration: {component_id: component.id}}
      }.to raise_exception('Invalid verifications, all verifications should be of type direct')
    end
  end
end
