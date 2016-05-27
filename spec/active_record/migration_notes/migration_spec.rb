require 'spec_helper'

describe ActiveRecord::Migration do
  subject { ActiveRecord::Migration.new }

  describe '#migrate' do
    it 'triggers the original aliased method' do
      expect(subject).to receive(:_original_migrate).with(:up)
      subject.migrate(:up)
    end

    describe 'message handling' do
      before :each do
        allow(subject).to receive(:_original_migrate)
        subject.version = 1
        subject.name = 'name'
      end
      context 'direction is up' do
        it 'adds the message if migration responds to up_notes' do
          expect(subject).to receive(:up_notes) { 'content' }
          expect(ActiveRecord::MigrationNotes::Handler.instance)
            .to receive(:add).with(1, 'name', 'content', :up)
          subject.migrate(:up)
        end
        it 'skips if migration has no up_notes method' do
          expect(ActiveRecord::MigrationNotes::Handler.instance)
            .not_to receive(:add)
          subject.migrate(:up)
        end
      end
      context 'direction is down' do
        it 'adds the message if migration responds to down_notes' do
          expect(subject).to receive(:down_notes) { 'content' }
          expect(ActiveRecord::MigrationNotes::Handler.instance)
            .to receive(:add).with(1, 'name', 'content', :down)
          subject.migrate(:down)
        end
        it 'skips if migration has no down_notes method' do
          expect(ActiveRecord::MigrationNotes::Handler.instance)
            .not_to receive(:add)
          subject.migrate(:down)
        end
      end
    end
  end
end
