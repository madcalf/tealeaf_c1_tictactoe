# Course 1. Lesson 1. Tic Tac Toe
require 'pry'

# these are patterns of array indexes into game_array that yield wins
WIN_PATTERNS =  [ [0, 1, 2], [3, 4, 5], [6, 7, 8], 
                  [0, 3, 6], [1, 4, 7], [2, 5, 8], 
                  [0, 4, 8], [2, 4, 6]
                ]
EMPTY = "."
PLAYER = {name: "Player", marker: "x"}
COMPUTER = {name: "Computer", marker: "o"}  


def print_array_as_grid(array)
  # just for debugging to visualize the board status
  # until we're actually drawing it
  puts "#{array[0..2]}"
  puts "#{array[3..5]}"
  puts "#{array[6..8]}"
end 

# computer needs to do things a bit differently
def computer_move(game_arr)
  index = look_for_win(game_arr)
  if !index 
    index = look_for_block(game_arr)
  end
  
  if index
   pos = index + 1
  else
    # no win or block, so go random
    pos = find_empty_pos(game_arr)
  end
  set_marker(game_arr, COMPUTER, pos)  
end

def set_marker(game_arr, which_player, pos)
  index = pos - 1
  if game_arr[index] == EMPTY
    game_arr[pos - 1] = which_player[:marker]
    puts "#{which_player[:name]} chose #{pos}"
    return true
  else
    return false
  end
end

def find_empty_pos(game_arr)
    index = game_arr.each_index.select { |i| game_arr[i] == EMPTY}.sample
    index ? (index + 1) : nil
end

def test_for_win(game_arr, which_player)
  # loop thru the winning index combos
  # for each combo, see if there's x's or o's in all 3 indexes of game_arr
  is_win = false
  WIN_PATTERNS.each_with_index do |list_of_indexes, i| 
    value_list = game_arr.values_at(*list_of_indexes)
    is_win = value_list.all? { |val| val == which_player[:marker]}
    break if is_win
  end
  return is_win
end

def test_for_end(game_arr)
  if test_for_win(game_arr, PLAYER)
    puts "#{PLAYER[:name].upcase} WINS!"
    true
  elsif test_for_win(game_arr, COMPUTER) 
    puts "#{COMPUTER[:name].upcase} WINS!"
    true
  elsif !find_empty_pos(game_arr)
    puts "TIE GAME!"
    true
  else
    false
  end
end

# only computer does this
# look thru the winning sequence indexes for 2 o's and EMPTY
# the EMPTY is where computer can win!
def look_for_win(game_arr)
  WIN_PATTERNS.each_with_index do |indexes, i| 
    values = game_arr.values_at(*indexes)
    can_win = values.select { |item| item == "o"}.size == 2
 
    # now get the empty index they need to win
    if can_win
      # find the index that's empty in the values list
      index1 = values.find_index { |item| item == EMPTY }
      # use that index to query indexes for the main index in game_array to block
      if (index1)
        # get the index into the game_array
        index2 = indexes[index1]
        return index2 
      end
    end
  end 
  return nil
end

# only computer does this
# look thru the winning sequence indexes for 2 x's and EMPTY
# the EMPTY is where computer needs to block player from winning
def look_for_block(game_arr)     
  # loop thru the winning index combos and see if we find
  # for each combo, see if there's 2 x's or o's in a row indexes of game_arr
  WIN_PATTERNS.each_with_index do |indexes, i| 
    values = game_arr.values_at(*indexes)
    can_block = values.select { |item| item == "x"}.size == 2
 
    # now get the empty index they need to block
    if can_block
      # find the index that's empty in the local values list
      index1 = values.find_index { |item| item == EMPTY }
      # get the index into the game_array
      if (index1)
        index2 = indexes[index1]
        return index2
      end
    end
  end
  return nil
end

# updates screen with our pseudo gameboard
def update(game_arr, msg = "\n")
  system 'clear'
  puts '----------------------------------'
  puts '          Tic Tac Toe'
  puts '----------------------------------'
  print_array_as_grid(game_arr)
  puts msg
end

# ------ END METHODS ------ 

system 'clear'
# sample game array with 1, 5, 9 as x
# looks like this: ["x", ".", ".", ".", "x", ".", "o", ".", "x"]
# game_array = Array.new(9, '.')

# main program loop
loop do  
  game_array = Array.new(9, '.')
  
  # game loop
  loop do
    
    # system 'clear'
    update(game_array, "Your turn:")
    
    # player's move
    begin
      input = gets.chomp.downcase
      break if set_marker(game_array, PLAYER, input.to_i)
      update(game_array, "Already taken! Pick another")
    end while true 

    puts "Player's turn done. Updating with no message"
    
    update(game_array)
    if test_for_end(game_array)
      puts "Play again?"
      gets.chomp.downcase == 'y' ? break : exit
    end
 
     puts "Computer's turn starting. Updating with 'my turn'"   
    # computer's move
    update(game_array, "Computer's turn" )
    computer_move(game_array)
  
    puts "Computer's turn done. Updating with no message"
   
    update(game_array)
    if test_for_end(game_array)
      puts "Play again?"
      gets.chomp.downcase == 'y' ? break : exit
    end
  end   # end game loop
end