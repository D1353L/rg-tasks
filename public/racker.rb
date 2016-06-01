require 'erb'
require 'json'

class Racker

  def call(env)
    @request = Rack::Request.new(env)
    case @request.path
      when '/' then index
      when '/set_username' then set_username
      when '/hint' then hint
      when '/verify_code' then verify_code
      when '/get_scores' then get_scores
      else not_found
    end
  end

  def render(template)
    path = File.expand_path("../views/#{template}", __FILE__)
    ERB.new(File.read(path)).result(binding)
  end

  def index
    start
    Rack::Response.new(render("index.html.erb"))
  end

  def set_username
    @username = @request[:username]
    Rack::Response.new("Hi #{@username}! Try to guess 4-digits code from 1 to 6")
  end



  def hint
    Rack::Response.new(@game.hint(@code.secret_code))
  end

  def verify_code
    begin
      result = @code.verify(@request[:guess])
      @win = @game.win?(result)
      endgame = false
      if @win
        message = 'You win!'
        endgame = true
        end_game
      elsif @game.attempts == 0
        message = 'Game over'
        endgame = true
        end_game
      else
        message = "Failure. Left #{@game.attempts} attempts."
      end
    rescue RuntimeError => e
      message = e.message
    end
    Rack::Response.new({result: result, endgame: endgame, message: message}.to_json)
  end

  def get_scores
    scores = Codebreaker::Game.new.load_scores('scores.yaml')
    scores.sort_by! { |hsh| hsh[:attempts] }
    Rack::Response.new(scores.to_json)
  end

  def start
    @code = Codebreaker::Code.new
    @game = Codebreaker::Game.new
  end

  def end_game
    @game.save_score(@username, @code.secret_code, @win, 'scores.yaml')
    @code = nil
    @game = nil
  end

  def not_found
    Rack::Response.new("Not Found", 404)
  end
end