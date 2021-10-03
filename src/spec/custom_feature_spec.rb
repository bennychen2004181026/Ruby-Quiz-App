# frozen_string_literal: true

require_relative '../models/Custom'

describe Custom do
  context 'When prepareing a container for a new quiz collecction with the add_empty_collection() method' do
    it 'should return an array with name that user provided ' do
      custom_name = '123'
      results = Custom.new.add_empty_collection(custom_name)
      expect(results.class).to eq(Array)
    end
    it 'should return an array with size 2 ' do
      custom_name = '123'
      results = Custom.new.add_empty_collection(custom_name)
      expect(results.size).to eq(2)
    end
    it 'should return an integer within the return array with index 1' do
      custom_name = '123'
      results = Custom.new.add_empty_collection(custom_name)
      expect(results[1].class).to eq(Integer)
    end
    it 'should return have a custom name key value pair in the collections object located in the array with index 0' do
      custom_name = '123'
      results = Custom.new.add_empty_collection(custom_name)
      object = results[0]
      value = object['Custom'].last['Custom_Name']
      expect(value).to eq(custom_name)
    end
  end
end
