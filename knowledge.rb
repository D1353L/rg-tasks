class Module
  def attribute(a, &block)
    case a
      when Hash
        name    = a.keys.first
        default = a[name]
      when String, Symbol
        name    = a
        default = nil
    end

    define_method(name.to_sym) do
      if instance_variable_defined?(:"@#{name}")
        instance_variable_get(:"@#{name}")
      else
        block ? instance_eval(&block) : default
      end
    end

    define_method(:"#{name}=") do |value|
      instance_variable_set(:"@#{name}", value)
    end

    define_method(:"#{name}?") do
      !!send(name.to_sym)
    end
  end
end