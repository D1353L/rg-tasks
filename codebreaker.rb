# Codebreaker
class Codebreaker
  attr_accessor :secret_code

  def initialize
    @secret_code = generate_code
  end

  def generate_code
    4.times.map { rand(1..6) }.join
  end

  def verify_code(code)
    raise 'Code size should be 4' unless code.size == 4
    raise 'Code digits should be in 1-6 range' if (code =~ /[1-6]{4}/).nil?

    result = ''
    code.chars.each_with_index do |dig, i|
      if secret_code[i] == dig
        result[0, 0] = '+'
      elsif secret_code.include? dig
        result << '-'
      end
    end
    result
  end
end
