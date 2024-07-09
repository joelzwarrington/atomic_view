# frozen_string_literal: true

require "atomic_view/helpers/form_tag_helper"

module AtomicView
  class Railtie < Rails::Railtie # rubocop:disable Style/Documentation
    initializer "atomic_view.helpers" do
      ActiveSupport.on_load(:action_view) { include AtomicView::Helpers }
    end
  end
end
