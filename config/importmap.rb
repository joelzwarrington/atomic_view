# frozen_string_literal: true

pin_all_from File.expand_path("../app/assets/javascripts", __dir__)

# Explicit pin for the gem's Stimulus controllers, so host apps can rely on
# `import "atomic_view/controllers/<name>_controller"` regardless of how the
# catch-all pin above is scoped in the future.
pin_all_from File.expand_path("../app/assets/javascripts/atomic_view/controllers", __dir__), under: "atomic_view/controllers"
