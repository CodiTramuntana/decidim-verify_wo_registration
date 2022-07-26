# frozen_string_literal: true

shared_examples 'has a proposal ready to vote' do
  let(:proposals_component) { create(:proposal_component, :with_votes_enabled) }
  let(:component) { proposals_component }
  let!(:proposal) { create(:proposal, component: proposals_component) }
  let(:resource) { proposal }
end

shared_examples 'has a budget ready to vote' do
  # votes enabled by default in budgets
  let(:manifest_name) { "proposals" }
  include_context "with a component"

  let(:component) do
    create(:proposal_component,
           manifest: manifest,
           participatory_space: participatory_process)
  end
  let(:proposal) { create(:proposal, component: component) }
  let(:budgets_component) do
    create(:component, manifest_name: :budgets, participatory_space: proposal.component.participatory_space)
  end

  let!(:project) { create(:project, component: budgets_component) }
  let(:resource) { project }
end

# Expects proposals_component, verification_permissions variables to exist.
shared_examples 'the component has supports_without_registration enabled' do
  let(:verification_permissions) { build_verification_permissions }

  before do
    component.attributes['settings']['global']['supports_without_registration'] = true
    component.permissions = verification_permissions
    component.save!
  end
end
