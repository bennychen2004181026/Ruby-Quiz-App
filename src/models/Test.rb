# frozen_string_literal: true

require_relative 'FileManager'
require_relative 'Default_backup'
require 'json'
# Test model is responsible for play quiz test feature.
# It has initialized time limited hash which set three timing that user can choose in the test, a default collection instance and
# a reset object to recover default collection file in case it's corrupted.
class Test
  include FileManager
  include DefaultReset
  attr_reader :time_level, :default, :reset

  def initialize
    @time_level = {
      "Easy": 16,
      "Normal": 12,
      "Hard": 8
    }
    @default = FileManager.load_default
    @reset
  end

  def reset_default(new_default)
    FileManager.save_default(new_default)
  end

  def default_content_setter
    @reset= DefaultReset.reset
    return @reset
  end
end
