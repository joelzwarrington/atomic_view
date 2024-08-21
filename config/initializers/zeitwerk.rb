Rails.autoloaders.main.ignore(Rails.root.join("lib"))
Rails.autoloaders.main.ignore(ViewComponent::Form::Engine.root.join("app", "components"))
Rails.autoloaders.main.ignore(ViewComponent::Form::Engine.root.join("app", "components", "concerns"))
Rails.autoloaders.main.ignore(Heroicon::Engine.root.join("app", "helpers"))
