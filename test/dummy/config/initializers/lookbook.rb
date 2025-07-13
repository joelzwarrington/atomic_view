Rails.application.configure do
  config.lookbook.project_name = "AtomicView"
  config.lookbook.ui_theme = "zinc"
  config.lookbook.project_logo = false
  config.lookbook.ui_favicon = false

  config.lookbook.page_route = "docs"
  config.lookbook.page_paths = [Rails.root.join("..", "..", "docs")]

  config.lookbook.preview_controller = "AtomicView::LookbookController"
  config.lookbook.preview_collection_label = "Components"
  config.lookbook.preview_paths = [Rails.root.join("..", "..", "previews")]

  config.lookbook.preview_display_options = {
    theme: ["light", "dark"]
  }
end
