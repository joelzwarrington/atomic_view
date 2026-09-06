# frozen_string_literal: true

module AtomicView
  module Components
    module Concerns
      module SectionSupport
        SECTION_OPTION_KEYS = %i[
          container_class
          left_section
          left_section_as_addon
          left_section_as_interaction
          right_section
          right_section_as_addon
          right_section_as_interaction
        ].freeze

        # The options hash minus the section/container keys SectionSupport
        # itself consumes -- pass this (not the raw `options`) to whatever
        # renders the actual `<input>`/`<select>` tag, so these keys don't
        # leak through as literal (invalid) HTML attributes.
        def options_without_sections
          options.except(*SECTION_OPTION_KEYS)
        end

        def container_html_class
          class_names(
            "relative rounded-lg shadow-xs",
            {"flex" => left_section_addon? || left_section_interaction? || right_section_addon? || right_section_interaction?},
            options[:container_class]
          )
        end

        def left_section
          options[:left_section]
        end

        def left_section?
          left_section.present?
        end

        def left_section_addon?
          options[:left_section_as_addon].present?
        end

        def left_section_interaction?
          options[:left_section_as_interaction].present?
        end

        def right_section
          options[:right_section] || method_errors? && raw(icon("exclamation-circle", variant: :mini, options: {class: "size-5 text-destructive"}))
        end

        def right_section?
          right_section.present?
        end

        def right_section_addon?
          options[:right_section_as_addon].present?
        end

        def right_section_interaction?
          options[:right_section_as_interaction].present?
        end
      end
    end
  end
end
