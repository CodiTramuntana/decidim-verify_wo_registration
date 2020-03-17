# frozen_string_literal: true

require "spec_helper"

RSpec.shared_context "does not create a new user" do
  it "does not create a new user" do
    expect { subject.call }.to change { Decidim::User.count }.by(0)
  end
end

module Decidim
  describe VerifyWoRegistration::DoVerifyWoRegistration do
    subject { described_class.new(form) }

    let(:document_number) { "00000000X" }
    let(:postal_code) { "00000" }
    let(:birthday) { "2000/01/01" }
    let(:metadata) do
      {
        document_number: document_number,
        postal_code: postal_code,
        birthday: birthday
      }
    end
    let(:handler_name) { 'dummy_authorization_handler' }
    let(:form_authorization) do
      {
        "0" => {"handler_name" => handler_name}.merge(metadata)
      }
      # {"0"=>{"handler_name"=>"dummy_authorization_handler", "document_number"=>"00000000X", "postal_code"=>"00000", "birthday"=>"23/06/6"}}
    end

    include_examples "has a proposal ready to vote"
    include_examples "the component has supports_without_registration enabled"
    let(:organization) { proposals_component.organization }

    let(:form) { ::Decidim::VerifyWoRegistration::VerifyWoRegistrationForm.from_params(form_params).with_context(form_context) }
    let(:form_params) do
      {
        authorizations: form_authorization,
        component_id: proposals_component.id,
        redirect_url: 'http://whatever.net/url',
      }
    end
    let(:form_context) do
      {
        current_organization: organization,
        current_component: proposals_component,
        # there's no current user as nobody is logged-in when verifying w/o registration
        # current_user: @controller.try(:current_user),
        current_participatory_space: proposals_component.participatory_space
      }
    end

    context "when the authorization already exists" do
      let!(:authorization) { create(:authorization, :granted, name: handler_name, metadata: metadata, unique_id: document_number, user: user) }

      # Cas 1: Si l'usuari que intenta fer l'acció de vot, ja existeix
      #  una autorització amb aquelles dades, li ha de dir que no pot, perquè 
      # ja existeix un usuari amb aquelles dades, i per tant no li ha de permetre fer el vot, 
      # si no dir-li que recuperi el seu usuari
      context "when a registered user with the same verification already exists" do
        let(:user) { create(:user, organization: organization) }

        it "should not verify but suggest the user to use the registered user" do
          expect(subject.call).to broadcast(:use_registered_user)
        end

        it_behaves_like "does not create a new user"
      end

      # Cas 2: Que existeixi un usuari impersonat prèviament amb les mateixes dades, 
      # per tant, ha de recuperar l'autorització prèvia i fer el login amb el mateix usuari, i no crear-ne un de nou
      context "when an impersonated user with the same verification already exists" do
        let(:user) { create(:user, :managed, organization: organization) }
        it "update the existing authorization and login with the same user" do
          previously_granted_at= authorization.granted_at
          expect(subject.call).to broadcast(:ok)
          expect(authorization.reload.granted_at).to be > previously_granted_at
        end

        it_behaves_like "does not create a new user"
      end
    end
  end
end
