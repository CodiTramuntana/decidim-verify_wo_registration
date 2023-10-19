# frozen_string_literal: true

require 'spec_helper'

describe 'Verification process', type: :system do
  shared_examples 'verifies without being registered' do
    def fill_the_verification_form_for_dummy_authorization_handler(data)
      within('#new_verify_wo_registration_') do
        fill_in 'verify_wo_registration[authorizations[0]][document_number]', with: data[:document_number]
        fill_in 'verify_wo_registration[authorizations[0]][postal_code]', with: data[:postal_code]
        fill_in 'verify_wo_registration[authorizations[0]][birthday]', with: data[:birthday]
        click_button 'Verify'
      end
    end

    context 'when correctly filling the form' do
      before do
        click_verify_only
        fill_the_verification_form_for_dummy_authorization_handler(document_number: '00000000X', postal_code: '00000', birthday: Date.new(2000, 1, 1))
      end

      it 'redirects to the previous page and renders a notice' do
        expect(page).to have_content('You have been successfully verified. You have 30min to participate.')
      end
    end

    context 'when filling the form with incorrect data' do
      before do
        click_verify_only
        fill_the_verification_form_for_dummy_authorization_handler(document_number: '12345678A', postal_code: '12345', birthday: Date.new(2021, 1, 27))
      end

      it 'redirects back to the form and renders the error' do
        expect(page).to have_selector('#new_verify_wo_registration_')
        expect(page).to have_content('There was a problem managing the participant.')
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
