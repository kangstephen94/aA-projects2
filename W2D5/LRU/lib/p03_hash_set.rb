require_relative 'p02_hashing'

class HashSet
  attr_reader :count

  def initialize(num_buckets = 8)
    @store = Array.new(num_buckets) { Array.new }
    @count = 0
  end

  def insert(num)
    if @count < num_buckets
      unless include?(num)
        self[num] << num
        @count += 1 
      end 
    else 
      resize!
      self[num] << num
      @count += 1
    end
  end

  def include?(num)
    self[num].each do |i|
      return true if i == num
    end
    false
  end

  def remove(num)
    if include?(num)
      self[num].delete(num)
      @count -= 1
    end
  end

  private

  def [](num)
    # optional but useful; return the bucket corresponding to `num`
    @store[(num.hash) % num_buckets]
  end

  def num_buckets
    @store.length
  end

  def resize!
    temp = @store
    @store = Array.new(num_buckets * 2) { Array.new }
    temp.each do |sub_arr|
      sub_arr.each {|num| self[num] << num}
    end
  end
end

