module ObjectSpace
  def self.count(klass)
    count = ObjectSpace.each_object(klass) {|x| x }
  end
end