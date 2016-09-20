require 'active_record'
require 'active_record/migration_notes/migration'
require 'active_record/migration_notes/handler'

ActiveSupport.on_load(:active_record) do
  require 'active_record/migration_notes/tasks'
end
require 'active_record/migration_notes/version'
