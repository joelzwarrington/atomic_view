class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  default_form_builder AtomicView::FormBuilder
end
