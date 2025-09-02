# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

### Development

- **Run tests**: `bin/rails test`

### Code Quality

- **Linting**: `standardrb` (uses Standard Ruby linter)
- **Auto-fix**: `standardrb --fix`

### Component Preview

- **View Lookbook**: Navigate to `/lookbook` when development server is running
- **Preview path**: Components are previewed in `previews/` directory

## Architecture

### Core Structure

AtomicView is a Rails Engine that provides a component library built on ViewComponent with first-class ActionView support.

**Key Architecture Points:**

1. **Engine-based**: Uses `AtomicView::Engine` to isolate namespace and integrate with host Rails apps
2. **ViewComponent integration**: All components inherit from `AtomicView::Component` which extends `ViewComponent::Base`
3. **Form components**: Leverages `view_component-form` with custom `AtomicView::FormBuilder`
4. **Tailwind CSS integration**: Uses `tailwindcss-rails` with `TailwindMerge` for class deduplication
5. **Icon system**: Integrates Heroicons via `heroicons` gem

### Component System

- **Base class**: `AtomicView::Component` (lib/atomic_view/component.rb:4)
- **Form builder**: `AtomicView::FormBuilder` uses ViewComponent::Form with Components namespace
- **Components location**: All components in `lib/atomic_view/components/`
- **Previews**: Lookbook previews in `previews/selection_and_input/` directory

### Key Files

- **Main entry**: `lib/atomic_view.rb` - gem initialization and configuration
- **Engine**: `lib/atomic_view/engine.rb` - Rails engine with Tailwind/importmap integration
- **Component base**: `lib/atomic_view/component.rb` - includes Heroicons helpers and TailwindMerge
- **Form builder**: `lib/atomic_view/form_builder.rb` - ViewComponent::Form integration

### Dependencies

- **Rails**: ~> 8.0.1
- **ViewComponent**: ~> 3.21 (component architecture)
- **view_component-form**: Form component integration
- **tailwindcss-rails**: ~> 4.3 (styling)
- **tailwind_merge**: ~> 0.12 (CSS class merging)
- **heroicons**: ~> 2.0 (icon system)
- **zeitwerk**: ~> 2.7.2 (autoloading)

### Testing

- Uses Rails test framework (not RSpec)
- Test helper in `test/test_helper.rb`
- Dummy app for testing in `test/dummy/`

### Asset Pipeline

- JavaScript: Uses importmap-rails for JS module management
- CSS: Tailwind CSS compilation via tailwindcss-rails
- Assets precompiled: `atomic_view/application.js`, `atomic_view/tailwind.css`
