# require the Aeon library
require File.dirname(__FILE__) + '/../lib/aeon'
Aeon.mode = :development

require 'ruby-prof'
require 'benchmark'

r = Aeon::Room.first

Benchmark.bmbm do |bm|
  bm.report("current") do
    width = 50
    height = 50
    
    x = 0; y = 0; z = 0; zone = 0
    
    rows = []
    rows << "+#{'-'*width}+"
    
    xbounds = x-(width/2)..x+(width/2)
    ybounds = y-(height/2)..y+(height/2)
    
    rooms = {}
    Aeon::Room.all(:x => xbounds, :y => ybounds, :z => z, :zone => zone).each do |r|
      rooms[[r.x, r.y]] = r
    end
    
    ybounds.to_a.reverse.each do |pointy|
      row = '|'
      xbounds.each do |pointx|
        if room = rooms[[pointx, pointy]]
          room == self ? row << "o" : row << room.glyph
        else
          row << " "
        end
      end
      rows << row + "|"
    end
    
    rows << "+#{'-'*width}+"
    rows.join("\n") + "\n"
  end
  
  bm.report("new") do 
    width = 50
    height = 50
    
    x = 0; y = 0; z = 0; zone = 0
    
    rows = []
    rows << "+#{'-'*width}+"
    
    xbounds = x-(width/2)..x+(width/2)
    ybounds = y-(height/2)..y+(height/2)
    
    rooms = {}
    repository.adapter.query('SELECT "x", "y" FROM "rooms" WHERE ("x" BETWEEN ?) AND ("y" BETWEEN ?) AND ("z" = ?) AND ("zone" = ?)', xbounds, ybounds, z, zone).each do |r|
      rooms[[r.x, r.y]] = r
    end
    
    ybounds.to_a.reverse.each do |pointy|
      row = '|'
      xbounds.each do |pointx|
        if room = rooms[[pointx, pointy]]
          room == self ? row << "o" : row << " ".on_green
        else
          row << " "
        end
      end
      rows << row + "|"
    end
    
    rows << "+#{'-'*width}+"
    rows.join("\n") + "\n"
  end
end


# result = RubyProf.profile do
#   r.draw_map(20,20)
# end
# 
# printer = RubyProf::GraphHtmlPrinter.new(result)
# printer.print(STDOUT, :min_percent=>0)