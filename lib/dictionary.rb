module Dictionary
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
  end
end