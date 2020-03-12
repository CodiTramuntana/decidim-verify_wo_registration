# frozen_string_literal: true

shared_examples "has a proposal ready to vote" do
  let(:proposals_component) { create(:proposal_component, :with_votes_enabled) }
  let!(:proposal) { create(:proposal, component: proposals_component) }
end

# Expects proposals_component, verification_permissions variables to exist.
shared_examples "the component has supports_without_registration enabled" do
  before do
    proposals_component.attributes["settings"]["global"]["supports_without_registration"]= true
    proposals_component.permissions= verification_permissions
    proposals_component.save!
  end


end