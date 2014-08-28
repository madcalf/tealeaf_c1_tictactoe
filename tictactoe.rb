# Course 1. Lesson 1. Tic Tac Toe
require 'pry'
require 'set'

# sample game array with 1, 5, 9 as x
# game_array: ["x", ".", ".", ".", "x", ".", "o", ".", "x"]
# these are patterns of array indexes into game_array that yield wins
WIN_PATTERNS =  [ [0, 1, 2], [3, 4, 5], [6, 7, 8], 
                  [0, 3, 6], [1, 4, 7], [2, 5, 8], 
                  [0, 4, 8], [2, 4, 6]
                ]
EMPTY = "."
PLAYER = {name: "Player", char: "x"}
COMPUTER = {name: "Computer", char: "o"}  

 
def print_array_as_grid(array)
  # just for debugging to visualize the board status
  # until we're actually drawing it
  puts "#{array[0..2]}"
  puts "#{array[3..5]}"
  puts "#{array[6..8]}"
end 

# make this take multiple optional args
# so we can add multiple x's for testing and such
def set_player_choice(arr, pos)
  arr[pos - 1] = "x"
end

def set_computer_choice(arr, pos)
  arr[pos - 1] = "o"
end

def set_choice(game_arr, which_player, pos)
  index = pos - 1
  if game_arr[index] == EMPTY
    game_arr[pos - 1] = which_player[:char]
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
  puts "test_for_win()"
  # loop thru the winning index combos
  # for each combo, see if there's x's or o's in all 3 indexes of game_arr
  is_win = false
  WIN_PATTERNS.each_with_index do |list_of_indexes, i| 
    value_list = game_arr.values_at(*list_of_indexes)
    is_win = value_list.all? { |val| val == which_player[:char]}
    break if is_win
  end
  return is_win
end

def test_for_end(game_arr)
  puts "test_for_end"
  if test_for_win(game_arr, PLAYER)
    puts "#{PLAYER[:name].upcase} WINS!"
    true
  elsif test_for_win(game_arr, COMPUTER) 
    puts "#{COMPUTER[:name].upcase} WINS!"
    true
  elsif !find_empty_pos(game_arr)
    puts "TIE GAME!"
  else
    false
  end    
end

# test for any 2 x's or o's in any of the win sequences
# e.g. x.x | xx. | .xx | .oo | o.o | oo.
# order doesn't matter, just get the space that's empty if there's 2!
def test_for_block(game_arr, player, player_to_block)     
  # loop thru the winning index combos and see if we find
  # for each combo, see if there's 2 x's or o's in a row indexes of game_arr
  char = player_to_block[:char]
  WIN_PATTERNS.each_with_index do |list_of_indexes, i| 
    value_list = game_arr.values_at(*list_of_indexes)
    # puts "TEST: #{value_list.find_index { |item| item != char }}"
    # puts "need_to_block: #{need_to_block}"
    need_to_block = value_list.select { |item| item == char}.size == 2
 
    # now get the index they need to block
    if need_to_block
      # find the index that's not char in the local 3 item value_list
      local_index_to_block = value_list.find_index { |item| item != char }
      puts "list_of_indexes: #{list_of_indexes}  local_index_to_block: #{local_index_to_block} } "
      # use that index to query list_of_indexes for the main index in game_array to block
      if (local_index_to_block)
        main_index_to_block = list_of_indexes[local_index_to_block]
        puts "#{player[:name]} needs to block at #{main_index_to_block} (position #{main_index_to_block + 1})]  #{value_list}" 
      end
    end
  end
    # is_win = value_list.all? { |val| val == player[:char]}
    # puts "#{player[:name]} WINS! value_list: #{value_list}" if is_win
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

def new_game(game_array)
  game_array = Array.new(9, '.')
end

# ------ END METHODS ------ 

system 'clear'
game_array = Array.new(9, '.')


# testing values
# set_choice(game_array, player, 1)
# set_choice(game_array, player, 4)
# set_choice(game_array, player, 7)

# set_choice(game_array, computer, 3)
# set_choice(game_array, computer, 6)
# set_choice(game_array, computer, 9)


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
      break if set_choice(game_array, PLAYER, input.to_i)
      update(game_array, "Already taken! Pick another")
    end while true 

    update(game_array, "" )
    if test_for_end(game_array)
      puts "Play again?"
      gets.chomp.downcase == 'y' ? break : exit
    end
    
    # computer's move
    update(game_array, "My turn" )
    pos = find_empty_pos(game_array)
    puts "computer pos: #{pos}"
    set_choice(game_array, COMPUTER, pos )
    update(game_array)
    
    if test_for_end(game_array)
      puts "Play again?"
      gets.chomp.downcase == 'y' ? break : exit
    end
  end   # end game loop
end