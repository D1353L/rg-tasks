# Core
class Core
  attr_accessor :secret_code

  def initialize
    generate_code
  end

  def generate_code
    @secret_code = 4.times.map { rand(1..6) }.join
  end

  def verify_code(code)
    raise 'Code size should be 4' unless code.size == 4
    raise 'Code digits should be in 1-6 range' if (code =~ /[1-6]{4}/).nil?
    result = ''
    secret_array = @secret_code.split('')
    code.chars.each_with_index do |dig, i|
      if secret_array[i] == dig
        secret_array[i] = nil
        result[0, 0] = '+'
      end
    end
    code.chars.each_with_index do |dig, i|
      result << '-' if secret_array.include?(dig) && !secret_array[i].nil?
    end
    result
  end
end
