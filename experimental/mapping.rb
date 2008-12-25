# require the Aeon library
require File.dirname(__FILE__) + '/../lib/aeon'
Aeon.mode = :development

require 'ruby-prof'
require 'benchmark'

r = Aeon::Room.first

Benchmark.bm do |x|
  x.report("2") { r.draw_map2 }
  x.report("1") { r.draw_map }
end


# result = RubyProf.profile do
#   r.draw_map
# end
# 
# printer = RubyProf::GraphHtmlPrinter.new(result)
# printer.print(STDOUT, :min_percent=>0)