# frozen_string_literal: true

require_relative '../models/History'

describe History do
  context 'After finish the test past all the attributes to the aadd_history_and_save() method to create and add new record to the history file' do
    it 'should return a Hash of the new history record ' do
      attributes = [3000, 10, 0, 'Default', 'aaa', 'bbb', 'Easy']
      object = History.new.add_history_and_save(attributes)
      result = object['Records'].last
      expect(result.class).to eq(Hash)
    end
    it 'should have a integer id in the new history record ' do
      attributes = [3000, 10, 0, 'Default', 'aaa', 'bbb', 'Easy']
      object = History.new.add_history_and_save(attributes)
      hash = object['Records'].last
      id = hash['Id']
      expect(id.class).to eq(Integer)
    end
    it 'should have a integer correct count of a quiz in the new history record ' do
      attributes = [3000, 10, 0, 'Default', 'aaa', 'bbb', 'Easy']
      object = History.new.add_history_and_save(attributes)
      hash = object['Records'].last
      count = hash['Correct']
      expect(count.class).to eq(Integer)
    end
  end
end
