# frozen_string_literal: true

require 'spec_helper'

shared_examples 'standard login modal' do
  it 'is the standard one' do
    expected_text = 'Please sign in'
    expect(page).to have_content(expected_text)
  end
end

describe 'Login modal', type: :system do
  before do
    switch_to_host(proposals_component.organization.host)
  end

  context 'when signed-out and a proposals component exists with votes enabled' do
    include_examples 'has a proposal ready to vote'

    describe 'when component has NOT verify w/o registration enabled' do
      context 'when going to support a given proposal' do
        before do
          go_support_resource_card(proposal)
        end

        it_behaves_like 'standard login modal'
      end
    end

    describe 'when component has verify w/o registration enabled' do
      include_examples 'the component has supports_without_registration enabled'

      context 'when going to support a given proposal' do
        before do
          go_support_resource_card(proposal)
        end

        describe 'the login modal' do
          let(:verification_permissions) { build_verification_permissions }

          it 'is the customized one' do
            expected_text = 'To participate you must be verified. How do you want to verify?'
            expect(page).to have_content(expected_text)
          end

          context 'when wanting to ignore registration and only verify' do
            it 'renders the handler form' do
              click_verify_only
            end
          end
        end

        context 'when no direct handlers are available' do
          let(:verification_permissions) { nil }

          it_behaves_like 'standard login modal'
        end
      end
    end
  end
end
