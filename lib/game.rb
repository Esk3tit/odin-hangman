require_relative 'fileio'

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
    loop do
      p @secret_word
      puts "Remaining wrong guesses: #{@num_guesses}"
      puts @guessed_letters.join(' ')
      print_incorrect_guesses
      guess = get_letter_guess
      if guess == '1'
        save_game
        break
      else
        update_guessed_letters(guess)
      end
      if is_win_or_lose?
        break
      end
    end
  end

  def select_secret_word
    FileIO.load_dictionary(@dictionary_file).sample
  end

  def get_letter_guess
    loop do
      print "Enter a letter for your guess (or enter 1 to save and quit): "
      guess = gets.chomp.downcase
      return guess if is_valid_guess?(guess)
      puts "Invalid guess. Please enter a single letter or 1."
    end
  end

  def is_valid_guess?(input)
    input.match?(/^[a-zA-Z1]$/)
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

  def is_win_or_lose?
    if @guessed_letters.join == @secret_word && @num_guesses > 0
      puts "Congratulations! You guessed the secret word: #{@secret_word}"
      return true
    elsif @num_guesses <= 0
      puts "You lose! The secret word was: #{@secret_word}"
      return true
    end
    false
  end

  def save_game
    filename = 'hangman_save.yaml'
    loop do
      print "Enter a save file name: "
      filename = gets.chomp
      # Add .yaml extension if not already present
      filename += '.yaml' unless filename.end_with?('.yaml')
      if File.exist?(filename)
        puts "File already exists. Overwrite? (Y/n) "
        response = gets.chomp.downcase
        if response == 'n'
          puts "Save aborted. Choose another file name."
        else
          break
        end
      else
        break
      end
    end

    game_state = {
      secret_word: @secret_word,
      num_guesses: @num_guesses,
      guessed_letters: @guessed_letters,
      incorrect_letters: @incorrect_letters.to_a # Convert Set to Array for YAML compatibility
    }

    if FileIO.save_game(game_state, filename)
      puts "Game saved as #{filename}"
    end
  end

  def load_game
    filename = 'hangman_save.yaml'
    game_state = nil
    loop do
      print "Enter a save file name to load (or 'cancel' to go back): "
      input = gets.chomp

      if input.downcase == 'cancel'
        puts "Loading save file canceled. Returning to menu..."
        return false
      end

      # Add .yaml extension if not already present
      filename = "#{input}.yaml" unless input.end_with?('.yaml')
      if File.exist?(filename)
        game_state = FileIO.load_game(filename)
        break
      else
        puts "The save file doesn't exist. Please try again."
      end
    end

    @secret_word = game_state[:secret_word]
    @num_guesses = game_state[:num_guesses]
    @guessed_letters = game_state[:guessed_letters]
    @incorrect_letters = game_state[:incorrect_letters]
    puts "Successfully loaded game data from save file #{filename}"
    true
  end
end