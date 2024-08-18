Rails.application.configure do
  config.lookbook.project_name = "AtomicView"
  config.lookbook.project_logo = false
  config.lookbook.preview_collection_label = "Component Previews"
  config.lookbook.preview_paths.push AtomicView.preview_folder_path
  config.lookbook.preview_display_options = {
    theme: ["light", "dark"]
  }
end
