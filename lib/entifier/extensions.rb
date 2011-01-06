class Hash
  # File merb/core_ext/hash.rb, line 166
  def nested_symbolize_keys!
    each do |k,v|
      sym = k.respond_to?(:to_sym) ? k.to_sym : k
      self[sym] = Hash === v ? v.nested_symbolize_keys! : v
      delete(k) unless k == sym
    end
    self
  end

  def nested_stringify_keys!
    each do |k,v|
      s = k.respond_to?(:to_s) ? k.to_s : k
      self[s] = Hash === v ? v.nested_stringify_keys! : v
      delete(k) unless k == s
    end
    self
  end

end