# frozen_string_literal: true

module AtomicView
  class LookbookController < if defined?(Lookbook)
                               Lookbook::PreviewController
                             else
                               ActionController::Base
                             end
    default_form_builder AtomicView::FormBuilder
  end
end
