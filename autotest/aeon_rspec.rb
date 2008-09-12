require 'autotest'

Autotest.add_hook :initialize do |at|
  at.clear_mappings
  at.add_exception(/\.git|db|doc|log/)
  
  # If spec_helper is modified, rerun all specs
  at.add_mapping(%r%^spec/spec_helper\.rb$%) do
    at.files_matching %r%^spec/.*_spec\.rb$%
  end
  
  # If a spec is modified, rerun that spec
  at.add_mapping(%r%^spec/.*_spec\.rb$%) do |filename, _|
    filename 
  end
  
  # If a library file is modified, run <filename>_spec.rb. If there is no
  # matching spec however, just rerun all specs.
  at.add_mapping(%r%^lib/(.*)\.rb$%) do |_, m| 
    match = at.files_matching %r{^spec/#{m[1]}_spec\.rb$}
    unless match.empty?
      match
    else
      at.files_matching %r%^spec/.*_spec\.rb$%
    end
  end
  
  # Last priority: Rerun all specs for any file not matched by the above.
  at.add_mapping(%r%(.*)%) do |_, m|
    at.files_matching %r%^spec/.*_spec\.rb$%
  end
end



# The below is copied from Autotest::Rspec (which is in RSpec, not in
# ZenTest), with the exception of the modification to consolidate_failures,
# explained below.

class RspecCommandError < StandardError; end

class Autotest::AeonRspec < Autotest

  def initialize
    super
    self.failed_results_re = /^\d+\)\n(?:\e\[\d*m)?(?:.*?Error in )?'([^\n]*)'(?: FAILED)?(?:\e\[\d*m)?\n(.*?)\n\n/m
    self.completed_re = /\n(?:\e\[\d*m)?\d* examples?/m
  end
  
  # Modified consolidate_failures from the version in Autotest::Rspec. This
  # method works by looking at the stack trace of each encountered failure and
  # pulling out the top-most file in the stack trace, adding it the failures
  # to be re-run. This works fine until an exception is raised in an actual
  # library file, in which case that file will be the top-most file in the
  # stack trace. So when Autotest re-runs the next time, it runs the library
  # file instead of the spec file. This is bad.
  #
  # Fixed the issue by simply modifying the regex below so that it only grabs
  # files ending in _spec.rb out of the stack trace to be rerun.
  #
  # -Brent
  def consolidate_failures(failed)
    filters = new_hash_of_arrays
    failed.each do |spec, trace|
      if trace =~ /\n(\.\/)?(.*_spec\.rb):[\d]+:\Z?/
        filters[$2] << spec
      end
    end
    return filters
  end
  
  def make_test_cmd(files_to_test)
    return "#{ruby} -S spec #{add_options_if_present} #{files_to_test.keys.flatten.join(' ')}"
  end
  
  def add_options_if_present # :nodoc:
    File.exist?("spec/spec.opts") ? "-O spec/spec.opts " : ""
  end

  # Finds the proper spec command to use.  Precendence is set in the
  # lazily-evaluated method spec_commands.  Alias + Override that in
  # ~/.autotest to provide a different spec command then the default
  # paths provided.
  def spec_command(separator=File::ALT_SEPARATOR)
    unless defined? @spec_command then
      @spec_command = spec_commands.find { |cmd| File.exists? cmd }

      raise RspecCommandError, "No spec command could be found!" unless @spec_command

      @spec_command.gsub! File::SEPARATOR, separator if separator
    end
    @spec_command
  end

  # Autotest will look for spec commands in the following
  # locations, in this order:
  #
  #   * bin/spec
  #   * default spec bin/loader installed in Rubygems
  def spec_commands
    [
      File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'bin', 'spec')),
      File.join(Config::CONFIG['bindir'], 'spec')
    ]
  end
end
