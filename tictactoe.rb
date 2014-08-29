# Course 1. Lesson 1. Tic Tac Toe
require 'pry'

# ==================== CONSTANTS ====================

# these are patterns of array indexes into game_array that yield wins
WIN_PATTERNS =  [ [0, 1, 2], [3, 4, 5], [6, 7, 8], 
                  [0, 3, 6], [1, 4, 7], [2, 5, 8], 
                  [0, 4, 8], [2, 4, 6]
                ]
EMPTY = "." # placeholder for empty square 
PLAYER = {name: "Player", marker: "x"}
COMPUTER = {name: "Computer", marker: "o"}  
SLEEP_TIME = 1
END_SLEEP_TIME = 1.3

# for drawing
SPACE2 = "  "
SPACE5 = "     "
TOP_LINE = " #{'_'*17} "
BOTTOM_LINE = "|#{'_'*17}|"
GRID_LINE = "#{'-'*5}+#{'-'*5}+#{'-'*5} "
GRID_MARKS = {'x' => {top:' \ / ', mid:'  \  ', bot:' / \ '}, 'o' => {top: ' === ', mid: ' | | ', bot:' === '}}

# ==================== METHODS ====================

def print_array_as_grid(array)
  # just for debugging to visualize the board status
  # until we're actually drawing it
  puts "#{array[0..2]}"
  puts "#{array[3..5]}"
  puts "#{array[6..8]}"
end 

def numeric?(str) 
  # using Float this way seems to be a popular way to do this on SO
  # anything wrong with it? 
  # is it ok to rely on an exception to set a value?
  begin 
    result = Float(str) ? true : false
  rescue
    result = false
  ensure
    return result
  end
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

def test_game_over(game_arr)
  if test_for_win(game_arr, PLAYER)
    draw(game_arr, "#{PLAYER[:name].upcase} WINS!")
    true
  elsif test_for_win(game_arr, COMPUTER) 
    draw(game_arr, "#{COMPUTER[:name].upcase} WINS!")
    true
  elsif !find_empty_pos(game_arr)
    draw(game_arr, "TIE GAME!")
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

def parse_mark mark, which_part
  if mark.class == Hash
    return mark[which_part]
  elsif which_part == :top || which_part == :bot
    return SPACE5
  else
    return "#{SPACE2}#{mark}#{SPACE2}"
  end
end
  
# updates screen with our pseudo gameboard
def draw(game_arr, msg = "\n")
  system 'clear'
  puts '----------------------------------'
  puts '          Tic Tac Toe'
  puts '----------------------------------'
  
  # just prints the array as 3 x 3 for testing
  # print_array_as_grid(game_arr) 
  
  marks = game_arr.each_with_index.map do |val, index|
    mark = val == EMPTY ? index + 1 : GRID_MARKS[val] 
  end
    
  # puts "#{TOP_LINE}"
  puts 
  puts "#{SPACE5}#{parse_mark(marks[0], :top)}|#{parse_mark(marks[1], :top)}|#{parse_mark(marks[2], :top)} "
  puts "#{SPACE5}#{parse_mark(marks[0], :mid)}|#{parse_mark(marks[1], :mid)}|#{parse_mark(marks[2], :mid)} "
  puts "#{SPACE5}#{parse_mark(marks[0], :bot)}|#{parse_mark(marks[1], :bot)}|#{parse_mark(marks[2], :bot)} "

  puts "#{SPACE5}#{GRID_LINE}"

  puts "#{SPACE5}#{parse_mark(marks[3], :top)}|#{parse_mark(marks[4], :top)}|#{parse_mark(marks[5], :top)} "
  puts "#{SPACE5}#{parse_mark(marks[3], :mid)}|#{parse_mark(marks[4], :mid)}|#{parse_mark(marks[5], :mid)} "
  puts "#{SPACE5}#{parse_mark(marks[3], :bot)}|#{parse_mark(marks[4], :bot)}|#{parse_mark(marks[5], :bot)} "

  puts "#{SPACE5}#{GRID_LINE}"

  puts "#{SPACE5}#{parse_mark(marks[6], :top)}|#{parse_mark(marks[7], :top)}|#{parse_mark(marks[8], :top)} "
  puts "#{SPACE5}#{parse_mark(marks[6], :mid)}|#{parse_mark(marks[7], :mid)}|#{parse_mark(marks[8], :mid)} "
  puts "#{SPACE5}#{parse_mark(marks[6], :bot)}|#{parse_mark(marks[7], :bot)}|#{parse_mark(marks[8], :bot)} "

  # puts "#{BOTTOM_LINE}"
  puts "\n#{msg}"
end

# ==================== PROGRAM START ==================== 

system 'clear'

# main program loop
loop do  
  game_array = Array.new(9, '.')
  
  # game loop
  loop do
    draw(game_array, "Your turn\nPick 1-9 to place your mark")
 
    # player's move
    begin
      input = gets.chomp.downcase
      if !numeric?(input)
        msg = "That's a letter! Pick a number 1-9"
      else
        break if set_marker(game_array, PLAYER, input.to_i)
        msg = "Already taken! Pick another"
      end
      draw(game_array, msg)
    end while true 
    
    # update screen and test game is over
    draw(game_array)
    if test_game_over(game_array)
      sleep END_SLEEP_TIME
      puts("Play again?")
      gets.chomp.downcase == 'y' ? break : exit
    end

    # update screen and switch player
    # computer's move
    draw(game_array, "Computer's turn" )
    computer_move(game_array)
    
    # update screen and test if game is over
    sleep SLEEP_TIME 
    draw(game_array)
    if test_game_over(game_array)
      sleep END_SLEEP_TIME
      puts("Play again?")
      gets.chomp.downcase == 'y' ? break : exit
    end
  end  # end game loop
end