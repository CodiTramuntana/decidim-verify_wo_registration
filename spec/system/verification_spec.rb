# frozen_string_literal: true

require 'spec_helper'

describe 'Verification process', type: :system do
  shared_examples 'verifies without being registered' do
    def fill_the_verification_form_for_dummy_authorization_handler
      within('#new_verify_wo_registration_') do
        fill_in 'verify_wo_registration[authorizations[0]][document_number]', with: '00000000X'
        fill_in 'verify_wo_registration[authorizations[0]][postal_code]', with: '00000'
        fill_in 'verify_wo_registration[authorizations[0]][birthday]', with: '2000/01/01'
        click_button 'Verify'
      end
    end

    context 'when correctly filling the form' do
      before do
        click_verify_only
        fill_the_verification_form_for_dummy_authorization_handler
      end

      it 'redirects to the previous page and renders a notice' do
        resource_title= resource.title.kind_of?(Hash) ? translated(resource.title) : resource.title
        expect(page).to have_content(resource_title)
        expect(page).to have_content('You have been successfully verified. You have 30min to participate.')
      end
    end
  end

  describe 'Proposals component' do
    include_examples 'has a proposal ready to vote'
    include_examples 'the component has supports_without_registration enabled'
    before { switch_to_host(component.organization.host) }

    before do
      go_support_resource_card(proposal)
    end

    it_behaves_like 'verifies without being registered'
  end

  describe 'Budgets component' do
    include_examples 'has a budget ready to vote'
    include_examples 'the component has supports_without_registration enabled'
    before { switch_to_host(component.organization.host) }

    before do
      go_support_resource_link(project)
    end

    it_behaves_like 'verifies without being registered'
  end
end
