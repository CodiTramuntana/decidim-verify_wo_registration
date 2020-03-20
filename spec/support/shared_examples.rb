# frozen_string_literal: true

shared_examples "has a proposal ready to vote" do
  let(:proposals_component) { create(:proposal_component, :with_votes_enabled) }
  let(:component) { proposals_component }
  let!(:proposal) { create(:proposal, component: proposals_component) }
end

shared_examples "has a budget ready to vote" do
  # votes enabled by default in budgets
  let(:budgets_component) { create(:budget_component) }
  let!(:project) { create(:project, component: budgets_component) }
end

# Expects proposals_component, verification_permissions variables to exist.
shared_examples "the component has supports_without_registration enabled" do
  let(:verification_permissions) { build_verification_permissions }

  before do
    component.attributes["settings"]["global"]["supports_without_registration"]= true
    component.permissions= verification_permissions
    component.save!
  end
end