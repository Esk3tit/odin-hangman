require_relative 'dictionary'

class Game

  attr_reader :secret_word

  def initialize(dict_file = 'google-10000-english-no-swears.txt')
    @dictionary_file = dict_file
    @secret_word = select_secret_word
    @num_guesses = 8
    @guessed_letters = Array.new(@secret_word.length, '_')
    @incorrect_letters = Set.new
  end

  def play
    p @secret_word
    puts "Remaining wrong guesses: #{@num_guesses}"
    puts @guessed_letters.join(' ')
    print_incorrect_guesses
    update_guessed_letters(get_letter_guess)
    p @secret_word
    puts "Remaining wrong guesses: #{@num_guesses}"
    puts @guessed_letters.join(' ')
    print_incorrect_guesses
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

  def update_guessed_letters(guess_letter)
    is_correct_guess = false
    @secret_word.each_char.with_index do |letter, index|
      if guess_letter == letter
        @guessed_letters[index] = guess_letter
        is_correct_guess = true
      end
    end
    if !is_correct_guess
      @num_guesses -= 1
      @incorrect_letters.add(guess_letter)
    end
  end

  def print_incorrect_guesses
    puts "Incorrect letters: #{@incorrect_letters.to_a.join(', ')}"
  end
end