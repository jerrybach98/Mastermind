# Use instance variables for state of game (turn number, secret code, feedback, names, configurable settings)
# local: Current guess, winner, code for evaluation, valid_input, etc

# Brainstorm:
#compare 1 dimensional code arrays to get guess array to indicate clues on each loop



# Logic to handle invalid inputs
# Class for game, codemaker, codebreaker
# Explain rules in console before playing
# Do a 12 round game loop

class Mastermind
  def initialize (computer, player)
    puts "Welcome to Mastermind. The object of Mastermind is to guess a secret code consisting of a series of 4 numbers between 1-6 with duplicates allowed. Each guess results in feedback narrowing down the possibilities of the code. The codebreaker tries to guess the pattern in order within twelve turns. The feedback will indicate whether a guess is correct in both number and position as (●) or indicate the existence of a correct code placed in the wrong position as (○).
    "
    @computer = computer
    @player = player
  end

  def play
    p computer_code = @computer.generate_code
    #p computer_code = [1, 1, 2, 2] 
    p guess = @player.make_guess
     compare_guess(computer_code, guess)
  end 

  def compare_guess(computer_code, guess)
    feedback_array = []
    # Returns true in match positions and counts number of trues in array
    positional_match = guess.map.with_index { |e, i| e == computer_code[i] }
    match_number = positional_match.count(true)
    feedback_array.fill("● ", feedback_array.size, match_number)

    # Remove positional matches from array
    modified_guess_array = guess.reject.with_index { |e, i| positional_match[i] }
    modified_code_array = computer_code.reject.with_index { |e, i| positional_match[i] }

    #Compares modified array
    exist_count = modified_guess_array.count{|e| modified_code_array.include?(e)}
    feedback_array.fill("○ ", feedback_array.size, exist_count)
    puts "Clues: #{feedback_array.join}"
    p feedback_array

  end

end

class Computer
  def generate_code
    puts "Enter your guess as a four digit code: Eg. 1326"
    Array.new(4) { rand(1...6) }
  end
end

class Player
  
  def make_guess
    loop do
      guess_code = gets.chomp
      substrings = guess_code.split(//).map(&:to_i)
      check = substrings.all? { |num| num.between?(1, 6)}
        if guess_code.length != 4 || check == false
          puts "Invalid input. Please enter a 4-digit code with digits between 1 and 6"
          next
        end
      break substrings
    end
  end

end

class GameBoard
end

computer = Computer.new
player = Player.new

start_game = Mastermind.new(computer, player)
start_game.play
