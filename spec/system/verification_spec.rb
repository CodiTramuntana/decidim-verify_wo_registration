# frozen_string_literal: true

require "spec_helper"

describe "Verification process", type: :system do

  before do
    switch_to_host(proposals_component.organization.host)
  end

  context "when signed-out and a proposals component exists with votes enabled" do
    let(:proposals_component) { create(:proposal_component, :with_votes_enabled) }
    let!(:proposal) { create(:proposal, component: proposals_component) }

    context "when component has NOT verify w/o registration enabled" do
      context "when going to support a given proposal" do
        before do
          go_support_proposal(proposal)
        end

        describe "the login modal" do
          it "is the standard one" do
            expected_text= "Please sign in"
            expect(page).to have_content(expected_text)
          end
        end
      end
    end

    context "when component has verify w/o registration enabled" do
      before do
        proposals_component.attributes["settings"]["global"]["supports_without_registration"]= true
        proposals_component.save!
      end

      context "when going to support a given proposal" do
        before do
          go_support_proposal(proposal)
        end

        describe "the login modal" do
          it "is the customized one" do
            expected_text= "To participate you must validate yourself. How do you want to participate?"
            expect(page).to have_content(expected_text)
          end
        end
      end

      context "when wanting to ignore registration and only verify" do
        
      end
    end
  end

  # - visits the list of proposals for the `proposals_component`.
  # - and clicks on the first "Support" button it finds
  # - it waits for the loginModal to appear
  def go_support_proposal(proposal)
    page.visit main_component_path(proposals_component)
    expect(page).to have_content(proposal.title)

    within ".card__support", match: :first do
      click_button "Support"
    end
    expect(page).to have_css("#loginModal", visible: true)
  end

end
