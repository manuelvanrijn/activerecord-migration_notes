require 'rails'

module ActiveRecord
  module MigrationNotes
    class Railtie < Rails::Railtie
      rake_tasks do
        load File.join(File.dirname(__FILE__), 'tasks.rake')
      end
    end
  end
end
