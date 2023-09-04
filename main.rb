# Use instance variables for state of game (turn number, secret code, feedback, names, configurable settings)
# local: Current guess, winner, code for evaluation, valid_input, etc


# rubocop,


# Module handles start by explaining rules and ending game
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
    puts " "
  end

  # Takes input to restart or end game, restarting game resets variables
  def play_again
    loop do
      puts "Play again? Y/N"
      restart = gets.chomp.downcase
        if restart == "n"
          puts "Thank you for playing!"
          exit
        elsif restart == "y"  
          break restart
        end
    end
  end

  def restart_game(restart)
    if restart == "y"
      @guesses_left = 12
      @codebreaker_win = false
      @round_number = 0
      choose_mode() 
    end
  end
end

class Mastermind
  include Game

  # Variables represent state of game
  def initialize (computer, player)
    introduction
    @computer = computer
    @start
    @player = player
    @round_number = 0
    @guesses_left = 12
    @codebreaker_win = false
  end

  def choose_mode
    puts "Enter: '1' to be the CODEBREAKER"
    puts "Enter: '2' to be the CODEMAKER"
    @start = @player.input_mode
    if @start == 1
      guess_mode
    elsif @start == 2
      breaker_mode
    end
  end 

  private
  # Player makes a code for computer to break
  def breaker_mode
    puts "Reminder: Code must be 4-digits with numbers between 1-6 (duplicates allowed)"
    puts "You are the CODEMAKER make a code for the computer to break and press ENTER (Eg. '1234'):"
    undeciphered_code = @player.make_guess

    12.times do 
      @guesses_left = 12 - @round_number
      puts "Guesses remaining: #{@guesses_left}"
      @round_number += 1

      
      guess = @computer.break_code(undeciphered_code)
      compare_guess(undeciphered_code, guess)

      if undeciphered_code == guess
        puts "You lose, CODEBREAKER figured out your code!"
        @codebreaker_win = true
        break guess
      end
    end

    if @codebreaker_win == false
      puts "You win, CODEBREAKER failed to figure out your code!"
    end

    restart = play_again()
    restart_game(restart)
  end

  # Computer generates code for human to figure out
  def guess_mode
    # Generate both code and game prompt in method
    p undeciphered_code = @computer.generate_code

    12.times do 
      @guesses_left = 12 - @round_number
      puts "Guesses remaining: #{@guesses_left}"
      @round_number += 1

      guess = @player.make_guess
      compare_guess(undeciphered_code, guess)

      if undeciphered_code == guess
        puts "You win, you figured out the CODEMAKER's code!"
        @codebreaker_win = true
        break guess
      end
    end

    if @codebreaker_win == false
      puts "You lose, you failed to figure out the CODEMAKER's code!"
    end

    restart = play_again()
    restart_game(restart)

  end 

  def compare_guess(undeciphered_code, guess)
    feedback_array = []
    # Returns true in matched positions and counts number of trues in array
    positional_match = guess.map.with_index { |e, i| e == undeciphered_code[i] }
    match_number = positional_match.count(true)
    feedback_array.fill("● ", feedback_array.size, match_number)

    # Remove true matches from array
    modified_guess_array = guess.reject.with_index { |e, i| positional_match[i] }
    modified_code_array = undeciphered_code.reject.with_index { |e, i| positional_match[i] }

    # Compares modified array for positions that exists
    exist_count = modified_guess_array.count{|e| modified_code_array.include?(e)}
    feedback_array.fill("○ ", feedback_array.size, exist_count)

    puts "#{guess} Clues: #{feedback_array.join}"
  end
end

# Computer randomly generates code and undeciphers code using random matches
class Computer
  def initialize
    @modified_array = Array.new(4) {rand(1..6)}
  end

  def generate_code
    puts " "
    puts "CODEMAKER has created a code, try to break it!"
    puts "Reminder: Code must be 4-digits with numbers between 1-6 (duplicates allowed)"
    puts "Enter your guess as a four digit code and press ENTER (Eg. '1234'):"
    Array.new(4) { rand(1...6) }
  end

  def break_code(undeciphered_code)
    array = Array.new(4) {rand(1..6)}

    array.each_with_index do |e, i|
      if e == undeciphered_code[i]
        @modified_array[i] = undeciphered_code[i]
      end
    end
    return @modified_array
  end
end


class Player
  # Handles input for both human inputs for guesses and code generation
  def make_guess
    loop do
      guess_code = gets.chomp.strip.gsub(/[\s,]+/, '')
      substrings = guess_code.split(//).map(&:to_i)
      check = substrings.all? { |num| num.between?(1, 6)}
        if guess_code.length != 4 || check == false
          puts "Invalid input, please enter a 4-digit code with digits between 1 and 6 (Eg. '1234')"
          next
        end
      break substrings
    end
  end

  # Input for mode choice
  def input_mode
    loop do
      input_value = gets.chomp.to_i
        if input_value == 1 || input_value == 2  
          break input_value
        else
          puts "Invalid choice. Please enter '1' to be the CODEBREAKER or '2' to be the CODEMAKER."
        end
    end
  end

end

# Create objects to start game
computer = Computer.new
player = Player.new
start_game = Mastermind.new(computer, player)
start_game.choose_mode

