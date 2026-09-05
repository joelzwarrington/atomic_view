# frozen_string_literal: true

module AtomicView
  module Components
    module Concerns
      module SectionSupport
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
