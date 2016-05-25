require_relative 'core.rb'
require_relative 'game.rb'

# Console
class Console
  def initialize
    @core = Core.new
    @game = Game.new
    p 'Welcome to Codebreaker app.'
    p 'Enter your name:'
    @name = gets.chomp
  end

  def start
    @game.send(:initialize)
    @core.generate_code
    p 'Try to guess 4-digits (1-6) code:'
    loop do
      begin
        result = @core.verify_code(user_input)
        @win = @game.win?(result)
        if @win
          p 'You win!'
          break
        else
          p result
          if @game.attempts == 0
            p 'Game over'
            break
          else
            p "Failure. Left #{@game.attempts} attempts."
          end
        end
      rescue RuntimeError => e
        p e.message
      end
    end
    @game.save_score(@name, @core.secret_code, @win)
    new_game_or_exit
  end

  def user_input
    if (input = gets.chomp) == 'hint'
      h = @game.hint(@core.secret_code)
      if h.nil?
        p 'All hints used'
      else
        p h
      end
      input = gets.chomp
    end
    input
  end

  def new_game_or_exit
    loop do
      p 'Do you want to start new game? (y/n)'
      answer = gets.chomp
      if answer.casecmp('y') == 0
        start
        break
      elsif answer.casecmp('n') == 0
        output_top10_scores
        exit
      else
        next
      end
    end
  end

  def output_top10_scores
    scores = @game.load_scores.sort_by { |hsh| hsh[:attempts] }

    print '#'.rjust(5), 'Name |'.rjust(15), 'Code |'.rjust(15)
    print 'Used attempts |'.rjust(15), 'Win/lose |'.rjust(15), "\n"

    scores[0..9].each_with_index do |hsh, i|
      print "#{i + 1}.".rjust(5)
      hsh.each_value do |val|
        print "#{val} |".rjust(15)
      end
      print "\n"
    end

    if scores.index(@game.score) > 9
      print '..............'.center(70), "\n"
      print "#{scores.index(@game.score) + 1}.".rjust(5)
      @game.score.each_value do |val|
        print "#{val} |".rjust(15)
      end
    end
  end
end

Console.new.start
