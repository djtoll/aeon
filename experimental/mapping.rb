# require the Aeon library
require File.dirname(__FILE__) + '/../lib/aeon'
Aeon.mode = :development

require 'ruby-prof'
require 'benchmark'

r = Aeon::Room.first

Benchmark.bm do |bm|
  bm.report { 1000.times {r.draw_map(50,50)} }
end


# result = RubyProf.profile do
#   r.draw_map(20,20)
# end
# 
# printer = RubyProf::GraphHtmlPrinter.new(result)
# printer.print(STDOUT, :min_percent=>0)