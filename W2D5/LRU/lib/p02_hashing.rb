class Fixnum
  # Fixnum#hash already implemented for you
end

class Array
  def hash 
    self.map.with_index {|el, idx| el*idx}.reduce(:+).hash
  end 
  # def hash
  #   sum = self.flatten.map.with_index do |el,idx| 
  #     hash_helper(el) * idx
  #   end.reduce(:+)
  #   sum.hash
  # end
  # 
  # def hash_helper(el)
  #   case el
  #   when el.is_a?(String)
  #     el.hash
  #   when el.is_a?(Hash)
  # 
  #   when el.is_a?(Integer)
  #     el
  #   end 
  # end
end 

class String
  def hash
    letters = self.chars
    letters.map.with_index {|el, idx| (el.ord) * idx}.reduce(:+).hash
  end
end

class Hash
  # This returns 0 because rspec will break if it returns nil
  # Make sure to implement an actual Hash#hash method
  def hash
    sum = 0
    self.each do |k,v|
      sum += k.hash * v.hash
    end
    sum.hash
  end
end
