require "bank_link/view_helpers"
require "rails/all"

module BankLink
  class Railtie < ::Rails::Railtie
    initializer "bank_link.helpers" do
      ActiveSupport.on_load(:action_view) do
        include BankLink::ViewHelpers
      end
    end
  end
end