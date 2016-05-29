require 'yaml'

module Codebreaker
  # Game
  class Game
    ATTEMPTS = 4
    HINTS = 1
    attr_reader :attempts, :hints, :score

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
      return nil unless hints > 0
      @hints -= 1
      secret_code.chars.sample
    end

    def save_score(name, code, win, path)
      @score = { name: name, code: code,
                 attempts: ATTEMPTS - @attempts, win: win ? :win : :lose }
      File.open(path, 'a') { |f| f.puts @score.to_yaml }
    end

    def load_scores(path)
      YAML.load_stream(File.open(path))
    end
  end
end
