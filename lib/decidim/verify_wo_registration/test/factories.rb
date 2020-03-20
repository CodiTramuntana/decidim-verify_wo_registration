# frozen_string_literal: true

require 'decidim/core/test/factories'

FactoryBot.define do
  factory :verify_wo_registration_component, parent: :component do
    name { Decidim::Components::Namer.new(participatory_space.organization.available_locales, :verify_wo_registration).i18n_name }
    manifest_name { :verify_wo_registration }
    participatory_space { create(:participatory_process, :with_steps) }
  end

  # Add engine factories here
end
