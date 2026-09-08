# frozen_string_literal: true

require "test_helper"

class AtomicView::Components::CommandPaletteComponentTest < ViewComponent::TestCase
  test "renders the dialog with the given id" do
    actual = render_inline(AtomicView::Components::CommandPaletteComponent.new(id: "example-command-palette")).to_html

    assert_includes(actual, "<dialog")
    assert_includes(actual, "id=\"example-command-palette\"")
  end

  test "always renders the command palette controller" do
    actual = render_inline(AtomicView::Components::CommandPaletteComponent.new(id: "example-command-palette")).to_html

    assert_includes(actual, "data-controller=\"atomic-view--command-palette\"")
  end

  test "renders a borderless search input wired to the input target and actions" do
    actual = render_inline(AtomicView::Components::CommandPaletteComponent.new(id: "example-command-palette", placeholder: "Jump to..."))

    input = actual.css("input").first
    assert_equal("search", input["type"])
    assert_equal("Jump to...", input["placeholder"])
    assert_includes(input["class"], "bg-transparent")
    assert_includes(input["class"], "border-0")
    assert_includes(input["class"], "focus:outline-none")
    assert_includes(input["class"], "focus:ring-0")
    assert_equal("input", input["data-atomic-view--command-palette-target"])
    assert_includes(input["data-action"], "input->atomic-view--command-palette#filter")
    assert_includes(input["data-action"], "keydown->atomic-view--command-palette#navigate")
  end

  test "defaults the search placeholder" do
    actual = render_inline(AtomicView::Components::CommandPaletteComponent.new(id: "example-command-palette"))

    assert_equal("Search...", actual.css("input").first["placeholder"])
  end

  test "renders a section label for each group" do
    actual = render_inline(AtomicView::Components::CommandPaletteComponent.new(
      id: "example-command-palette",
      sections: [
        {label: "Pages", results: [{label: "Dashboard", href: "/dashboard"}]},
        {label: "Actions", results: [{label: "Create new park", href: "/parks/new"}]}
      ]
    )).to_html

    assert_includes(actual, "Pages")
    assert_includes(actual, "Actions")
    assert_includes(actual, "text-xs font-semibold uppercase text-muted-foreground")
  end

  test "renders a result row per result with the given href" do
    actual = render_inline(AtomicView::Components::CommandPaletteComponent.new(
      id: "example-command-palette",
      sections: [{label: "Pages", results: [{label: "Dashboard", href: "/dashboard"}]}]
    ))

    row = actual.css("a").find { |node| node.text.include?("Dashboard") }
    assert_equal("/dashboard", row["href"])
  end

  test "renders no sections by default" do
    actual = render_inline(AtomicView::Components::CommandPaletteComponent.new(id: "example-command-palette")).to_html

    assert_not_includes(actual, "role=\"group\"")
  end

  test "does not render a footer bar by default" do
    actual = render_inline(AtomicView::Components::CommandPaletteComponent.new(id: "example-command-palette")).to_html

    assert_not_includes(actual, "border-t border-border bg-offset")
  end

  test "renders a footer bar when the footer slot is given" do
    actual = render_inline(AtomicView::Components::CommandPaletteComponent.new(id: "example-command-palette")) do |palette|
      palette.with_footer { "Type # to access projects." }
    end.to_html

    assert_includes(actual, "border-t border-border bg-offset")
    assert_includes(actual, "Type # to access projects.")
  end

  test "gives the results container a predictable id for turbo_stream targeting" do
    actual = render_inline(AtomicView::Components::CommandPaletteComponent.new(id: "example-command-palette")).to_html

    assert_includes(actual, "id=\"example-command-palette-results\"")
  end

  test "appends a consumer-supplied controller rather than overwriting the default" do
    actual = render_inline(
      AtomicView::Components::CommandPaletteComponent.new(id: "example-command-palette", data: {controller: "extra-controller"})
    ).to_html

    assert_includes(actual, "data-controller=\"atomic-view--command-palette extra-controller\"")
  end

  test "merges input_data into the input, appending to the default actions" do
    actual = render_inline(
      AtomicView::Components::CommandPaletteComponent.new(
        id: "example-command-palette",
        input_data: {action: "input->extra#search", testid: "search-input"}
      )
    )

    input = actual.css("input").first
    assert_equal("input", input["data-atomic-view--command-palette-target"])
    assert_equal("search-input", input["data-testid"])
    assert_includes(input["data-action"], "input->atomic-view--command-palette#filter")
    assert_includes(input["data-action"], "keydown->atomic-view--command-palette#navigate")
    assert_includes(input["data-action"], "input->extra#search")
  end

  test "merges custom class and forwards other options" do
    actual = render_inline(
      AtomicView::Components::CommandPaletteComponent.new(id: "example-command-palette", class: "custom-palette", data: {testid: "palette"})
    ).to_html

    assert_includes(actual, "custom-palette")
    assert_includes(actual, "data-testid=\"palette\"")
  end
end
