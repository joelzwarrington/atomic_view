# frozen_string_literal: true

namespace :atomic_view do
  desc 'Installs AtomicView'
  task install: :environment do
    Rails::Command.invoke :generate, ['atomic_view:install']
  end

  desc 'Updates Tailwind configuration'
  task update_tailwind: :environment do
    Rails::Command.invoke :generate, %w[atomic_view:install --update-tailwind-only]
  end
end
