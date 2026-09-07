# frozen_string_literal: true

require "test_helper"

class AtomicView::ComponentTest < ViewComponent::TestCase
  class IconComponent < AtomicView::Component
    erb_template <<~ERB
      <%= icon("check") %>
    ERB
  end

  test "#icon returns html_safe output so it isn't escaped when rendered" do
    actual = render_inline(IconComponent.new).to_html

    assert_includes(actual, "<svg")
    assert_not_includes(actual, "&lt;svg")
  end
end
