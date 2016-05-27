# rubocop:disable Style/FileName
require 'active_record'
# rubocop:enable Style/FileName
require 'active_record/migration_notes/migration'
require 'active_record/migration_notes/handler'
require 'active_record/migration_notes/railtie' if defined? Rails
require 'active_record/migration_notes/version'
