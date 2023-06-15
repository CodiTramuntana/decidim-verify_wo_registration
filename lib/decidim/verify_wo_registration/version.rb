# frozen_string_literal: true

module Decidim
  # This holds the decidim-meetings version.
  module VerifyWoRegistration
    VERSION = '0.1.0'
    DECIDIM_VER = '>= 0.27'

    def self.version
      VERSION
    end

    def self.decidim_version
      DECIDIM_VER
    end
  end
end
