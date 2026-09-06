// Import and register all your controllers from the importmap under controllers/*

import { application } from "controllers/application";

// Eager load all controllers defined in the import map under controllers/**/*_controller
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading";
eagerLoadControllersFrom("controllers", application);

// atomic_view's controllers are NOT eager-loaded the same way: the gem
// can't register into a host app's own Stimulus Application instance (see
// each JS-backed component's "Host app setup" docs), so this dummy app
// mirrors exactly what a real host app is told to do. Note this also
// isn't just a style choice -- eagerLoadControllersFrom("atomic_view", ...)
// derives an identifier from the pinned path's segments *after* "atomic_view/"
// (here, "controllers/toast_controller" -> "controllers--toast"), which
// doesn't match "atomic-view--toast", the identifier every atomic_view
// component's data-controller attribute actually uses -- so the controller
// would register under the wrong name and never connect.
import ChipController from "atomic_view/controllers/chip_controller";
import CommandPaletteController from "atomic_view/controllers/command_palette_controller";
import DropdownController from "atomic_view/controllers/dropdown_controller";
import ModalController from "atomic_view/controllers/modal_controller";
import ToastController from "atomic_view/controllers/toast_controller";

application.register("atomic-view--chip", ChipController);
application.register("atomic-view--command-palette", CommandPaletteController);
application.register("atomic-view--dropdown", DropdownController);
application.register("atomic-view--modal", ModalController);
application.register("atomic-view--toast", ToastController);

// Lazy load controllers as they appear in the DOM (remember not to preload controllers in import map!)
// import { lazyLoadControllersFrom } from "@hotwired/stimulus-loading"
// lazyLoadControllersFrom("controllers", application)
