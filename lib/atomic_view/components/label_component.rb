module AtomicView
  module Components
    class LabelComponent < ViewComponent::Form::LabelComponent
      def html_class
        "block text-sm font-medium leading-6 text-zinc-950 dark:text-white"
      end
    end
  end
end
