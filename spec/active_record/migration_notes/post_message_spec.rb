require 'spec_helper'

describe ActiveRecord::MigrationNotes do
  it 'has a version number' do
    expect(ActiveRecord::MigrationNotes::VERSION).not_to be nil
  end
end
