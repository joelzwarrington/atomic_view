// Import and register all your controllers from the importmap under controllers/*

import { application } from "controllers/application";

// Eager load all controllers defined in the import map under controllers/**/*_controller
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading";
eagerLoadControllersFrom("controllers", application);

// atomic_view's own Stimulus controllers need no separate call here: the
// gem pins them under "controllers/atomic_view/<name>_controller" (see
// config/importmap.rb in the gem), so the eager-load call above already
// discovers and registers them -- Stimulus' own subfolder-namespacing
// rule turns that path into the "atomic-view--<name>" identifier every
// atomic_view component's data-controller attribute uses.

// Lazy load controllers as they appear in the DOM (remember not to preload controllers in import map!)
// import { lazyLoadControllersFrom } from "@hotwired/stimulus-loading"
// lazyLoadControllersFrom("controllers", application)
