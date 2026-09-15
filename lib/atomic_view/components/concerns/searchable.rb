# frozen_string_literal: true

module AtomicView
  module Components
    module Concerns
      # Shared by SelectComponent/CollectionSelectComponent: `searchable:
      # true` progressively enhances the real, native `<select>` (kept in
      # the DOM -- visually hidden, but still the actual form value) with a
      # trigger + search + list combobox on top, wired to
      # `atomic-view--searchable-select`. That controller reads the
      # select's own `<option>` elements to build its list -- there's no
      # separate Ruby-side data source to keep in sync -- and writes back
      # into the select's value (dispatching `change`) when an option is
      # picked, so it participates in a real form submission exactly like
      # a plain select (e.g. FiltersComponent's form-level auto-submit)
      # with no special-casing.
      module Searchable
        def searchable?
          options[:searchable].present?
        end

        # `html_options` (the real <select>'s raw HTML attributes, kept
        # separate from `options` by ViewComponent::Form::SelectComponent)
        # needs the target attribute merged in only when searchable --
        # every select_tag override should render with this instead of
        # the raw `html_options`.
        def searchable_html_options
          return html_options unless searchable?

          html_options.merge(data: (html_options[:data] || {}).merge("atomic-view--searchable-select-target" => "select"))
        end

        # The searchable UI's controllers need to live on the same
        # container the real <select> is already inside of (so it's a
        # valid Stimulus target scope) -- that's `container_html_class`'s
        # div (from SectionSupport), already `position: relative` for
        # icon-section positioning, reused here as the dropdown's anchor
        # too rather than introducing another wrapping element.
        def searchable_container_data
          return {} unless searchable?

          {controller: "atomic-view--dropdown atomic-view--searchable-select"}
        end
      end
    end
  end
end
