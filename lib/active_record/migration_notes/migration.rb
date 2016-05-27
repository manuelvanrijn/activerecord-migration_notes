module ActiveRecord
  class Migration
    alias _original_migrate migrate

    def migrate(direction)
      _original_migrate(direction)
      case direction
      when :up
        return unless respond_to?(:up_notes)
        MigrationNotes::Handler.instance.add(version, name, up_notes, :up)
      when :down
        return unless respond_to?(:down_notes)
        MigrationNotes::Handler.instance.add(version, name, down_notes, :down)
      end
    end
  end
end
