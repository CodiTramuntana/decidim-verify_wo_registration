module Helpers

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

  # In the loginModal, click the button to start verifying.
  def click_verify_only
    within "#loginModal .row .content", match: :first do
      click_link "I have no user and I do not want to"
    end
    expect(page).to have_content("Participant verification")
  end

  # Returs A Hash with a Component#permissions's value setted with a dummy_authorization_handler for the vote action.
  def create_verification_permissions
    {"vote"=>{"authorization_handlers"=>{"dummy_authorization_handler"=>{"options"=>{"postal_code"=>"08001"}}}}}
  end
end
