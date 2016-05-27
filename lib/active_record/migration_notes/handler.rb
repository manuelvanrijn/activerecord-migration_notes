require 'singleton'

module ActiveRecord
  module MigrationNotes
    class Handler
      include Singleton

      attr_accessor :notes

      def initialize
        @notes = []
      end

      def add(version, name, content, direction = :up)
        content = '   ' + content.split("\n").map(&:strip).join("\n   ")
        notes << { version: version, name: name, content: content,
                   direction: direction }
      rescue
        nil
      end

      def output
        migration_notes unless notes.empty?
        @notes = []
      end

      private

      def migration_notes
        migration_notes_header

        notes.each do |note|
          say_message(note)
        end

        migration_notes_footer
      end

      def say_message(note)
        puts title(note)
        puts note[:content]
        puts '' unless notes.last == note
      end

      def title(note)
        title = case note[:direction]
                when :up    then '»» MIGRATED'
                when :down  then '«« REVERTED'
                end
        title += " - #{note[:name]}"
        len = [0, 77 - (title.length + note[:version].to_s.length)].max
        format('%s %s %s', colorize(title, 33), ' ' * len, note[:version])
      end

      def migration_notes_header
        text = 'MIGRATION NOTES:'
        len = [0, 75 - text.length].max
        puts format('== %s %s', colorize(text, 36), '=' * len)
      end

      def migration_notes_footer
        puts '=' * 79
      end

      def colorize(str, color_code)
        return str unless terminal_supports_colors?
        "\e[#{color_code}m#{str}\e[0m"
      end

      def terminal_supports_colors?
        cmd = 'which tput>/dev/null 2>&1 && [[ $(tput -T$TERM colors) -ge 8 ]]'
        system(cmd)
      end
    end
  end
end
