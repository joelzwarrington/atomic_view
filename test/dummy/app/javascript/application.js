// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "controllers"
import "@hotwired/turbo-rails"

// Playing the role of a host app here (see the "local-time" pin comment in
// the engine's config/importmap.rb): TimelineComponent's ItemComponent
// renders <time> elements via local_time's `local_time_ago` helper, but
// nothing upgrades them to the visitor's local time/relative phrasing
// without this -- per local_time's own Importmap install docs.
import LocalTime from "local-time"
LocalTime.start()
document.addEventListener("turbo:morph", () => {
  LocalTime.run()
})
