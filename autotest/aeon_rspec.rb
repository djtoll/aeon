class Autotest::AeonRspec < Autotest
  Autotest.add_hook :initialize do |at|
    at.add_exception(/\.git|db|doc|log|autotest/)
  end
end