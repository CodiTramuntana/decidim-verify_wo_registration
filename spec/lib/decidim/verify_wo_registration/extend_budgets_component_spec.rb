# frozen_string_literal: true

require "spec_helper"

describe "extend budgets settings" do
  let(:component) { Decidim.find_component_manifest :budgets }
  let(:settings) { component.settings }

  context "global settings" do
    let(:global_settings) { settings[:global] }

    it "has a 'supports without registration' attribute" do
      attribute= global_settings.schema.attribute_set.find { |a| a.name == :supports_without_registration }
      expect(attribute).to be_present
      expect(attribute.type).to eq(Axiom::Types::Boolean)
    end
  end
end
