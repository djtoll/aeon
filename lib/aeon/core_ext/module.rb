class Module
  
  def attr_accessor_with_default(sym, default = nil, &block)
    raise 'Default value or block required' unless !default.nil? || block
    define_method(sym, block_given? ? block : Proc.new { default })
    module_eval(<<-EVAL, __FILE__, __LINE__)
      def #{sym}=(value)
        class << self; attr_reader :#{sym} end
        @#{sym} = value
      end
    EVAL
  end
  
end