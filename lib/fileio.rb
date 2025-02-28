require 'yaml'
require 'set'

module FileIO
  MIN_WORD_LENGTH = 5
  MAX_WORD_LENGTH = 12

  def self.load_dictionary(filepath)
    candidate_words = []
    File.foreach(filepath) do |line|
      word = line.strip
      if word.length.between?(MIN_WORD_LENGTH, MAX_WORD_LENGTH)
        candidate_words << word
      end
    end
    return candidate_words
  rescue Errno::ENOENT
    raise "Dictionary file not found: #{filepath}"
  end

  def self.save_game(game_state, filename = 'hangman_save.yaml')
    File.write(filename, YAML.dump(game_state))
    true
  end

  def self.load_game(filename = 'hangman_save.yaml')
    game_state = YAML.load(File.read(filename))
    # Convert array back to Set if needed
    game_state[:incorrect_letters] = Set.new(game_state[:incorrect_letters]) if game_state[:incorrect_letters]
    return game_state
  end
end