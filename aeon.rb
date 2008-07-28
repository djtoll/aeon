require 'lib/aeon'

if __FILE__ == $0
  case ARGV.first
  when nil
    Aeon::Server.start
  when 'tt'
    # $stdout = File.new('/dev/null', 'w')
    fork { Aeon::Server.start }
    system 'tt++ config/tt++.config'
  end
end