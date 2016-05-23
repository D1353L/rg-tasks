require_relative 'core.rb'

#Game
class Game

  ATTEMPTS = 4
  HINTS = 1

  def initialize
    @core = Core.new
    p 'Welcome to Codebreaker app.'
    p 'Enter your name:'
    @name = gets.chomp
  end

  def start
    @attempts = ATTEMPTS
    @hints = HINTS
    @core.generate_code
    p 'Try to guess 4-digits (1-6) code:'
    begin
      begin
        break if win?(@core.verify_code(get_user_input))
      rescue RuntimeError => e
        p e.message
      end
    end while @attempts > 0
    new_game_or_exit
  end

  def get_user_input
    if (input = gets.chomp) == 'hint'
      hint
      input = gets.chomp
    end
    input
  end

  def win?(result)
    @win = false
    if result == '++++'
      p 'You win!'
      @win = true
    else
      p result
      @attempts -=1
      if @attempts == 0
        p 'Game over'
      else
        p "Failure. Left #{@attempts} attempts."
      end
    end
    @win
  end

  def hint
    if @hints > 0
      p @core.secret_code[rand(0..3)]
      @hints -=1
    else
      p 'All hints used'
    end
  end

  def new_game_or_exit
    begin
      p 'Do you want to start new game? (y/n)'
      answer = gets.chomp
      start if answer == 'y'
      exit if answer == 'n'
    end while answer.downcase != 'y' || answer.downcase != 'n'
  end

  def save_score

  end

  def get_scores

  end
end

Game.new.start