# frozen_string_literal: true

module Helpers
  # Expects the resource to be in a card-m.
  #
  # - visits the list of +resource+s for the current `component`.
  # - and clicks on the first "Support" button it finds
  # - it waits for the loginModal to appear
  def go_support_resource_card(resource)
    page.visit main_component_path(component)
    expect(page).to have_content(resource.title.kind_of?(Hash) ? translated(resource.title) : resource.title)

    within '.card__support', match: :first do
      click_button 'Support'
    end
    expect(page).to have_css('#loginModal', visible: true)
  end

  # Expects the resource to be in a link.
  #
  # - visits the list of +resource+s for the current `component`.
  # - and clicks on the first "Support" button it finds
  # - it waits for the loginModal to appear
  def go_support_resource_link(resource)
    page.visit main_component_path(component)
    expect(page).to have_content(resource.title.kind_of?(Hash) ? translated(resource.title) : resource.title)

    page.find('a[data-toggle=loginModal]').click

    expect(page).to have_css('#loginModal', visible: true)
  end

  # In the loginModal, click the button to start verifying.
  def click_verify_only
    within '#loginModal .row .content', match: :first do
      click_link 'I have no user and I do not want to'
    end
    expect(page).to have_content('Participant verification')
  end

  # Returs A Hash with a Component#permissions's value setted with a dummy_authorization_handler for the vote action.
  def build_verification_permissions
    { 'vote' => { 'authorization_handlers' => { 'dummy_authorization_handler' => { 'options' => { 'postal_code' => '08001' } } } } }
  end
end
