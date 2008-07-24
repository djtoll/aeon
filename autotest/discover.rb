# Autotest.add_discovery do
#   "aeon"
# end

Autotest.add_hook :initialize do |at|
  at.add_exception(/\.git|db|doc|log/)
end