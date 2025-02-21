require_relative 'dictionary'

class Game

  attr_reader :secret_word

  def initialize(dict_file = 'google-10000-english-no-swears.txt')
    @dictionary_file = dict_file
    @secret_word = select_secret_word
  end

  def play
    p @secret_word
    p get_letter_guess
  end

  def select_secret_word
    Dictionary.load_dictionary(@dictionary_file).sample
  end

  def get_letter_guess
    loop do
      print "Enter a letter for your guess: "
      guess = gets.chomp.downcase
      return guess if is_valid_guess?(guess)
      puts "Invalid guess. Please enter a single letter."
    end
    
  end

  def is_valid_guess?(input)
    input.match?(/^[a-zA-z]$/)
  end
end