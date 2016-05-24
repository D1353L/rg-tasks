require_relative 'core.rb'
require 'yaml'

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
    p @core.generate_code
    p 'Try to guess 4-digits (1-6) code:'
    begin
      begin
        break if win?(@core.verify_code(get_user_input))
      rescue RuntimeError => e
        p e.message
      end
    end while @attempts > 0
    save_score
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
      if answer == 'n'
        output_top10_scores
        exit
      end
    end while answer.downcase != 'y' || answer.downcase != 'n'
  end

  def save_score
    @score = {name: @name, code: @core.secret_code, attempts: ATTEMPTS - @attempts, win: @win ? :win : :lose}
    File.open('scores.yaml', 'a') { |f| f.puts @score.to_yaml }
  end

  def get_scores
    YAML.load_stream(File.open('scores.yaml'))
  end

  def output_top10_scores
    scores = get_scores.sort_by { |hsh| hsh[:attempts] }

    print '#'.rjust(5), 'Name |'.rjust(10), 'Code |'.rjust(10)
    print 'Attempts |'.rjust(10), 'Win/lose |'.rjust(10), "\n"

    scores[0..9].each_with_index do |hsh, i|
      print "#{i+1}.".rjust(5)
      hsh.each_value do |val|
        print "#{val} |".rjust(10)
      end
      print "\n"
    end

    if scores.index(@score) > 9
      print '......'.center(44), "\n"
      print "#{scores.index(@score)+1}.".rjust(5)
      @score.each_value do |val|
        print "#{val} |".rjust(10)
      end
    end
  end
end

Game.new.start