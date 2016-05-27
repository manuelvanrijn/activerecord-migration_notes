task :migration_notes do
  ActiveRecord::MigrationNotes::Handler.instance.output
end

%w(db:migrate db:rollback).each do |task|
  Rake::Task[task].enhance do
    Rake::Task[:migration_notes].invoke
  end
end
