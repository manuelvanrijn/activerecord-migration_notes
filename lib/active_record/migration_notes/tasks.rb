require 'rake'
# unless Rake::Task.task_defined?('db:migrate')
#   load 'active_record/railties/databases.rake'
# end

task :migration_notes do
  ActiveRecord::MigrationNotes::Handler.instance.output
end

%w(db:migrate db:rollback).each do |task|
  puts 'a'
  Rake::Task[task].enhance do
    # ActiveRecord::MigrationNotes::Handler.instance.output
    Rake::Task[:migration_notes].invoke
  end
end
