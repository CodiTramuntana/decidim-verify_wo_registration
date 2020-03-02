# frozen_string_literal: true

module Decidim
  module VerifyWoRegistration
    # This is the engine that runs on the public interface of `VerifyWoRegistration`.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::VerifyWoRegistration::Admin

      paths["db/migrate"] = nil
      paths["lib/tasks"] = nil

      routes do
        # Add admin engine routes here
        # resources :verify_wo_registration do
        #   collection do
        #     resources :exports, only: [:create]
        #   end
        # end
        # root to: "verify_wo_registration#index"
      end

      def load_seed
        nil
      end
    end
  end
end
