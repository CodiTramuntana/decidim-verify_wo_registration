# frozen_string_literal: true

require "spec_helper"

RSpec.shared_examples "has global setting" do |attr_name, attr_type|
  it "has attribute" do
    attribute= global_settings.schema.attribute_set.find { |a| a.name == attr_name }
    expect(attribute).to be_present
    expect(attribute.type).to eq(attr_type)
  end  
end

describe "extend gloal settings" do
  context "budgets settings" do
    let!(:component_manifest) { Decidim.find_component_manifest :budgets }
    let(:global_settings) { component_manifest.settings(:global) }

    it_behaves_like "has global setting", :supports_without_registration, Axiom::Types::Boolean
  end

  context "proposals settings" do
    let!(:component_manifest) { Decidim.find_component_manifest :proposals }
    let(:global_settings) { component_manifest.settings(:global) }

    it_behaves_like "has global setting", :supports_without_registration, Axiom::Types::Boolean
  end
end
