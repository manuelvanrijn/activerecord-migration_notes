require 'spec_helper'

describe ActiveRecord::MigrationNotes::Handler do
  subject { ActiveRecord::MigrationNotes::Handler.instance }

  it 'initializes with an empty message array' do
    expect(subject.notes).to eq []
  end

  before :each do
    subject.notes = []
  end
  describe '#add' do
    it 'adds the input as message' do
      subject.add(1234, 'test', 'some content')
      expect(subject.notes.count).to eq 1
    end
    it 'rescues if something goes wrong' do
      expect(subject.add(nil, nil, nil)).to eq nil
      expect(subject.notes.count).to eq 0
    end
    describe 'formats the content' do
      it 'removes the trailing spaces at the beginnen and adds 3 spaces instead' do
        content = "line
          text
                some more"
        subject.add(1, 'test', content)
        expect(subject.notes.first[:content]).to eq "   line\n   text\n   some more"
      end
    end
  end

  describe '#output' do
    it 'skips the call migration_notes if there are no messages' do
      expect(subject).not_to receive(:migration_notes)
      subject.output
    end
    it 'calls migration_notes if there are messages' do
      subject.add(1234, 'test', 'some content')
      expect(subject).to receive(:migration_notes)
      subject.output
    end
    it 'clears the messages afterwards' do
      subject.add(1234, 'test', 'some content')
      allow(subject).to receive(:migration_notes)
      expect(subject.notes.count).to eq 1
      subject.output
      expect(subject.notes.count).to eq 0
    end
  end

  describe '#migration_notes' do
    it 'calls the header and footer' do
      expect(subject).to receive(:migration_notes_header)
      expect(subject).to receive(:migration_notes_footer)
      subject.send(:migration_notes)
    end
    it 'loops trough the messages and calls say_message' do
      allow(subject).to receive(:migration_notes_header)
      allow(subject).to receive(:migration_notes_footer)

      expect(subject.notes).to receive(:each).and_yield 1
      expect(subject).to receive(:say_message).with(1)
      subject.send(:migration_notes)
    end
  end

  describe '#say_message' do
    before :each do
      subject.notes = []
      subject.add(1, 'name-1', 'content-1', :up)
      subject.add(2, 'name-2', 'content-2', :down)
    end
    it 'outputs the version and name and content' do
      expect(subject).to receive(:puts).with("\e[33m»» MIGRATED - name-1\e[0m                                                          1")
      expect(subject).to receive(:puts).with('   content-1')
      expect(subject).to receive(:puts).with('')
      subject.send(:say_message, subject.notes.first)
    end
    it 'will not add a blank line if message was the last message' do
      expect(subject).to receive(:puts).with("\e[33m«« REVERTED - name-2\e[0m                                                          2")
      expect(subject).to receive(:puts).with('   content-2')
      expect(subject).not_to receive(:puts).with('')
      subject.send(:say_message, subject.notes.last)
    end
  end

  describe '#migration_notes_header' do
    it 'outputs the header text' do
      header = "== \e[36mMIGRATION NOTES:\e[0m ==========================================================="
      expect(subject).to receive('puts').with(header)
      subject.send(:migration_notes_header)
    end
  end

  describe '#migration_notes_footer' do
    it 'outputs the footer text' do
      footer = '==============================================================================='
      expect(subject).to receive('puts').with(footer)
      subject.send(:migration_notes_footer)
    end
  end

  describe '#colorize' do
    it 'returns the str if terminal_supports_colors? is false' do
      expect(subject).to receive(:terminal_supports_colors?) { false }
      expect(subject.send(:colorize, 'content', 36)).to eq 'content'
    end
    it 'returns the color formatted string' do
      expect(subject).to receive(:terminal_supports_colors?) { true }
      expect(subject.send(:colorize, 'content', 36)).to eq "\e[36mcontent\e[0m"
    end
  end

  describe '#terminal_supports_colors?' do
    it 'executes the system call to check terminal color support' do
      cmd = 'which tput>/dev/null 2>&1 && [[ $(tput -T$TERM colors) -ge 8 ]]'
      expect(subject).to receive(:system).with(cmd)
      subject.send(:terminal_supports_colors?)
    end
  end
end
