require_relative "./board"
require_relative "./player"
require 'json'

class Engine

  POSITION = %w[1 2 3 4 5 6 7 8 9]
  
  # this will start game and
  # automatically terminate the game if player wins the game
  def start(x_player, o_player, board)
    puts "\n >> PLEASE SEE THE POSITIONS OF THE BOARD << \n\n"
    player = which_player
    puts "\nYour player is 'X' and computer plays with 'O'\n\n"
    if %w[N n].include?(player)
      current_player = o_player
    else
      current_player = x_player
    end

    (1..9).each do
      if current_player == x_player
        play(current_player, board)
        current_player = o_player
      else
        play(current_player, board)
        current_player = x_player
      end
    end
  end

  def which_player
    print "Do you want to play first? <y/n>: "
    ans = gets.chomp
    which_player unless %[N n Y y].include? ans
    ans
  end

  def stop
    puts "\n************* Match Draw ****************\n\n"
  end

  def play(current_player, board)
    if current_player.mark == "X"
      flag = true

      while flag do
        puts ""
        puts "Where do want to move? <1-9>: "
        position = gets.chomp
        valid_position = POSITION.include?(position)
        invalid_input_error_msg = "\nInvalid input, Please choose number between 1 to 9\n" 
        position_occupied = %w[X O].include? board.positions_with_values[position]
        already_occupied_error_msg = "\nPosition already occupied, Please choose another number...\n"
        puts invalid_input_error_msg unless valid_position
        puts already_occupied_error_msg if position_occupied
        flag = false if valid_position && !position_occupied
      end
      current_player.move(board, position, self)
    else
      current_player.best_move(board, self)
    end
  end

  def check_winner(board)
    x_count = 0
    o_count = 0
    Board::WINNING_PLACES.each do |winning_place|
      winning_place.each do |index|
        x_count += 1 if board.positions_with_values["#{index}"] == "X"
        o_count += 1 if board.positions_with_values["#{index}"] == "O"
      end
      if x_count == 3 or o_count == 3
        break
      else
        x_count = 0
        o_count = 0
      end
    end
    return "X won" if x_count == 3
    return "O won" if o_count == 3
    return "No One"
  end

  def display_winner(mark)
    puts "\n~~~~~~~~~~~~~~~| Result |~~~~~~~~~~~~~~~~"
    if mark == "X"
      puts "Congratulation!!!, you won the game\n\n"
    else
      puts "Sorry, you lost the game :( \n\n"
    end
    exit
  end

end

engine = Engine.new
x_player = Player.new("X")
o_player = Player.new("O") # This is a computer user.
board    = Board.new
board.display_positions

engine.start(x_player, o_player, board)
engine.stop # if match is draw
