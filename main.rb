# Build the game assuming the computer randomly selects the secret colors and the human player must guess them. Remember that you need to give the proper feedback on how good the guess was each turn!
# Use instance variables for state of game (turn number, secret code, feedback, names, configurable settings)
# local: Current guess, winner, code for evaluation, valid_input, etc

# Brainstorm:
#compare 1 dimensional code arrays to get guess array to indicate clues on each loop
# Do a 12 round game loop
# Take guess on each round, award hint for correct position
# if number matches number in array award +1

# 1 2 3 4
# 1 5 4 3 [⚫ ○ ○]
# Gives 1 number match and 1 direct match
# number match = number match - direct match
# 1 number in the wrong place, 1 number in the right place


# clues: add solid clue for correct position and guess, and empty circle for correct guess but not right position 
# Class for game, codemaker, codebreaker
# Explain rules in console before playing
#

class Mastermind
  def initialize (computer, player)
    puts "Welcome to Mastermind. The object of Mastermind is to guess a secret code consisting of a series of 4 numbers between 1-6 with duplicates allowed. Each guest results in feedback narrowing down the possibilities of the code. The codebreaker tries to guess the pattern in order within twelve turns. The feedback will indicate whether a guess is correct in both number and position as (⚫) or indicate the existence of a correct code placed in the wrong position as (○).
    "
    @computer = computer
    @player = player
  end

  def play
    #p computer_code = @computer.generate_code
    p computer_code = [1, 1, 3, 4]
    p guess = @player.make_guess
    p compare_guess(computer_code, guess)
  end 

  def compare_guess(computer_code, guess)
    feedback_array = []
    positional_match = guess.map.with_index { |x,i| x == computer_code[i] }
    match_number = positional_match.count(true)
    unformatted = feedback_array.fill("⚫", feedback_array.size, match_number)
    #formatted_array = "[" + unformatted.join("").gsub('"', '') + "]"

    #logic for number match


  end

end

class Computer
  def generate_code
    puts "Enter your guess as a four digit code: Eg. 1326"
    Array.new(4) { rand(1...6) }
  end
end

class Player
  def initialize
  end
  def make_guess
    guess_code = gets.chomp
    substrings = guess_code.split(//).map(&:to_i)
  end
end

class GameBoard
end

computer = Computer.new
player = Player.new

start_game = Mastermind.new(computer, player)
start_game.play