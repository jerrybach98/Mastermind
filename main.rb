# Use instance variables for state of game (turn number, secret code, feedback, names, configurable settings)
# local: Current guess, winner, code for evaluation, valid_input, etc
# If there's an "is-a" relationship, class inheritance is usually the correct choice. If there's a "has-a" relationship,

# Brainstorm:
#compare 1 dimensional code arrays to get guess array to indicate clues on each loop



# Logic to handle invalid inputs
# convert 1, 2, 3, 4 or 1 2 3 4 to > 1234
# Class for game, codemaker, codebreaker
# Explain rules in console before playing
# Do a 12 round game loop

module Game
  def introduction 
    puts "Welcome to Mastermind!"
    puts " "
    puts "The objective of Mastermind is to guess a secret code consisting of four numbers between 1-6 with duplicates allowed."
    puts "Each guess results in feedback narrowing down the possibilities of the code."
    puts "The codebreaker tries to guess the pattern in order within twelve turns."
    puts " "
    puts "Clues:"  
    puts "● This clue means you have 1 correct number in the right location."
    puts "○ This clue means you have 1 correct number in the wrong location."
    puts " "
    puts "Example:"
    puts "Code: [1, 2, 3, 4]"
    puts "Guess: [1, 5, 3, 2] Clues: ● ● ○"
    puts " "
    puts "Lets begin! Press ENTER to start:"
  end
end

class Mastermind
  include Game

  def initialize (computer, player)
    introduction
    @start = gets.chomp
    @computer = computer
    @player = player
    @round_number = 0
    @codebreaker_win = false
  end

  def play
    p computer_code = @computer.generate_code

    12.times do 
      guesses_left = 12 - @round_number
      puts "Guesses remaining: #{guesses_left}"
      @round_number += 1

      guess = @player.make_guess
      compare_guess(computer_code, guess)

      if computer_code == guess
        puts "Code guessor wins!"
        @codebreaker_win = true
        break guess
      end
    end

    if @codebreaker_win == false
      puts "Code guessor loses and Codemaker wins!"
    end

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
    puts "#{guess} Clues: #{feedback_array.join}"

  end

end

class Computer
  def generate_code
    puts "Code generated, try to break the code!"
    puts "Enter your guess as a four digit code and press enter (Eg. 1234):"
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

computer = Computer.new
player = Player.new

start_game = Mastermind.new(computer, player)
start_game.play


# 12 round game loop, instructions, game module