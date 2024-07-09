# AtomicView

Component library built for [Ruby on Rails](https://rubyonrails.org/) with first-class support for [ActionView](https://guides.rubyonrails.org/action_view_overview.html) using [ViewComponent](https://viewcomponent.org/).

## Installation

Install AtomicView from [RubyGems](https://rubygems.org/) by adding it to your `Gemfile`, and then bundling.

```ruby
# Gemfile
gem "atomic_view"
```

```shell
bundle install
```

In your `tailwind.config.js`, add:

```js
const execSync = require("child_process").execSync;
const atomicViewPath =
  execSync("bundle show atomic_view", { encoding: "utf-8" }).trim() +
  "/lib/atomic_view/components/**/*.{erb,rb}";

module.exports = {
  content: [
    // other paths...
    atomicViewPath,
  ],
};
```

## Getting Started

There isn't anything to get started on yet!

## Leading principles

1. Work with Ruby on Rails out of the box by supporting ActionView and it's helpers
2. Build with accessibility and responsiveness at the forefront
3. Provide really good defaults, but allow flexibility with theming and styling

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
