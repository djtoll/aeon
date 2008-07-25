require 'autotest'

Autotest.add_hook :initialize do |at|
  at.clear_mappings
  at.add_exception(/\.git|db|doc|log/)
  
  # If spec_helper is modified, run all specs
  at.add_mapping(%r%^spec/spec_helper\.rb$%) {
    at.files_matching %r%^spec/.*_spec\.rb$%
  }
  
  # If a spec is modified, run that spec
  at.add_mapping(%r%^spec/.*\.rb$%) { |filename, _|
    filename 
  }
  
  # If a library file is modified, run {filename}_spec.rb. If there is no
  # matching spec however, just rerun all specs.
  at.add_mapping(%r%^lib/(.*)\.rb$%) { |_, m| 
    match = at.files_matching %r{^spec/#{m[1]}_spec\.rb$}
    unless match.empty?
      match
    else
      at.files_matching %r%^spec/.*_spec\.rb$%
    end
  }
  
  # Last priority: Rerun all specs for any file not matched by the above.
  # This still excludes the files specified by add_exception, of course.
  at.add_mapping(%r%(.*)%) { |_, m|
    at.files_matching %r%^spec/.*_spec\.rb$%
  }
end


class RspecCommandError < StandardError; end

class Autotest::AeonRspec < Autotest

  def initialize
    super
    self.failed_results_re = /^\d+\)\n(?:\e\[\d*m)?(?:.*?Error in )?'([^\n]*)'(?: FAILED)?(?:\e\[\d*m)?\n(.*?)\n\n/m
    self.completed_re = /\n(?:\e\[\d*m)?\d* examples?/m
  end
  
  def consolidate_failures(failed)
    filters = new_hash_of_arrays
    failed.each do |spec, trace|
      if trace =~ /\n(\.\/)?(.*spec\.rb):[\d]+:\Z?/
        filters[$2] << spec
      end
    end
    return filters
  end
  
  

  def make_test_cmd(files_to_test)
    return "#{ruby} -S #{spec_command} #{add_options_if_present} #{files_to_test.keys.flatten.join(' ')}"
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
