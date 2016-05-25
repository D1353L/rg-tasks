require 'yaml'

# Game
class Game
  ATTEMPTS = 4
  HINTS = 1

  attr_accessor :attempts, :hints, :score
  def initialize
    @attempts = ATTEMPTS
    @hints = HINTS
  end

  def win?(result)
    win = false
    result == '++++' ? win = true : @attempts -= 1
    win
  end

  def hint(secret_code)
    if @hints > 0
      @hints -= 1
      return secret_code[rand(0...secret_code.size)]
    end
    nil
  end

  def save_score(name, code, win)
    @score = { name: name, code: code,
               attempts: ATTEMPTS - @attempts, win: win ? :win : :lose }
    File.open('scores.yaml', 'a') { |f| f.puts @score.to_yaml }
  end

  def load_scores
    YAML.load_stream(File.open('scores.yaml'))
  end
end
