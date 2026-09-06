# frozen_string_literal: true

pin_all_from File.expand_path("../app/assets/javascripts", __dir__)

# Explicit pin for the gem's Stimulus controllers, so host apps can rely on
# `import "atomic_view/controllers/<name>_controller"` regardless of how the
# catch-all pin above is scoped in the future.
pin_all_from File.expand_path("../app/assets/javascripts/atomic_view/controllers", __dir__), under: "atomic_view/controllers"

# `bin/importmap pin @floating-ui/dom` failed (the jspm.io generate API used
# by importmap-rails returned a 500), so this is pinned manually to
# jsDelivr's `+esm` bundle -- unlike jspm's `ga.jspm.io` build, jsDelivr's
# `+esm` output resolves its `@floating-ui/core`/`@floating-ui/utils`
# imports as same-origin absolute paths rather than bare specifiers, so it
# works as a single self-contained pin with no extra import map entries.
# Used by `dropdown_controller.js`.
pin "@floating-ui/dom", to: "https://cdn.jsdelivr.net/npm/@floating-ui/dom@1.8.0/+esm"
