# Use instance variables for state of game (turn number, secret code, feedback, names, configurable settings)
# local: Current guess, winner, code for evaluation, valid_input, etc
# If there's an "is-a" relationship, class inheritance is usually the correct choice. If there's a "has-a" relationship,

# Brainstorm:
#compare 1 dimensional code arrays to get guess array to indicate clues on each loop



# Refactor code to allow human player to choose
# Add computer strategy >  start by having the computer guess randomly, but keep the ones that match exactly.
# array = [" ", " ", " ", " "]
# Code = [1, 2, 3, 4]
# Generate random code and match it to array
# Eg [1, 3, 5, 6]
# if numbers match set the index position and fill in the array
# once the array matches end the loop



# object orient code, rubocop, private

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
    puts "Lets begin!"
    puts "Enter: '1' to be the CODEBREAKER"
    puts "Enter: '2' to be the CODEMAKER"
    puts " "
  end
end

class Mastermind
  include Game

  def initialize (computer, player)
    introduction
    puts @start = gets.chomp.to_i
    @computer = computer
    @player = player
    @round_number = 0
    @codebreaker_win = false
  end

  def choose_mode
    if @start == 1
      guess_mode
    elsif @start == 2
      breaker_mode
    else 
      puts "Invalid choice. Please enter '1' to be the CODEBREAKER or '2' to be the CODEMAKER."
    end
  end 

  def breaker_mode
    puts "You are the CODEMAKER make a code for the computer to break and press ENTER (Eg. '1234'):"
    p computer_code = @player.make_guess

    12.times do 
      guesses_left = 12 - @round_number
      puts "Guesses remaining: #{guesses_left}"
      @round_number += 1

      
      guess = @computer.break_code(computer_code)
      compare_guess(computer_code, guess)

      if computer_code == guess
        puts "CODEBREAKER wins!"
        @codebreaker_win = true
        break guess
      end
    end

    if @codebreaker_win == false
      puts "CODEBREAKER loses and CODEMAKER wins!"
    end

  end

  def guess_mode
    p computer_code = @computer.generate_code

    12.times do 
      guesses_left = 12 - @round_number
      puts "Guesses remaining: #{guesses_left}"
      @round_number += 1

      guess = @player.make_guess
      compare_guess(computer_code, guess)

      if computer_code == guess
        puts "CODEBREAKER wins!"
        @codebreaker_win = true
        break guess
      end
    end

    if @codebreaker_win == false
      puts "CODEBREAKER loses and CODEMAKER wins!"
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
  def initialize
    @modified_array = Array.new(4) {rand(1..6)}
  end

  def generate_code
    puts "Code generated, try to break the code!"
    puts "Enter your guess as a four digit code and press enter (Eg. '1234'):"
    Array.new(4) { rand(1...6) }
  end

  def break_code(computer_code)
    array = Array.new(4) {rand(1..6)}

    array.each_with_index do |e, i|
      if e == computer_code[i]
        @modified_array[i] = computer_code[i]
      end
    end
    return @modified_array
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

  def input_mode
    loop do
      input_value = gets.chomp.to_i
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
  start_game.choose_mode
