require_relative 'lib/game'

loop do
  print "Enter 1 to play a new game or 2 to load a save file and play: "
  input = gets.chomp
  game = Game.new
  if input == '1'
    game.play
    break
  elsif input == '2'
    if game.load_game
      game.play
      break
    end
  else
    puts "Invalid input. Please try again."
  end
end
