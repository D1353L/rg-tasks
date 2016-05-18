class Factory
  def self.new(*keys, &block)
    Class.new do
      send(:attr_accessor, *keys)

      send(:define_method, :initialize) do |*values|
        raise "Wrong number of arguments. #{values.size} for #{keys.size}" if values.size != keys.size
        values.each_with_index {|v, i| send("#{keys[i]}=", v)}
      end

      send(:define_method, :[]) do |index|
        index.is_a?(Fixnum) ? send("#{keys[index]}") : send("#{index}")
      end

      class_eval(&block) if block_given?

      send(:define_method, :==) do |other|
        return false if self.class != other.class
        keys.each {|k| return false if self[k] != other[k]}
        true
      end

      send(:define_method, :[]=) do |key, value|
        key.is_a?(Fixnum) ? send("#{keys[key]}=", value) : send("#{key}=", value)
      end
	  
	  send(:define_method, :each) do |&block|
		if block_given? && !block.nil?
			keys.each {|k| block.call self[k]}
		else
			values = Array.new
			keys.each {|k| values << self[k]}
			values.each
		end
	  end
	  
	  send(:define_method, :each_pair) do |&block|
		if block_given? && !block.nil?
			keys.each {|k| block.call k, self[k]}
		else
			values = Hash.new
			keys.each {|k| values[k] = self[k]}
			values.each
		end
	  end
	  
	  send(:define_method, :eql?) do |other|
        return false if self.class != other.class
        keys.each {|k| return false unless self[k].eql?(other[k])}
        true
      end
    end
  end
end

f1 = Factory.new(:ha, :ja, :iac)
a = f1.new("a", "s", "p")
c = f1.new("a", "s", "b")
f2 = Factory.new(:name, :addr) do
  def greet
    "Hello, #{name}"
  end
end

b = f2.new("ssa", "aaa")

b["name"] = "Name"
b[1] = "Earth"
p b
b.each_pair {|name, value| p ("#{name} => #{value}")}
p b.each_pair
p a.eql? a
