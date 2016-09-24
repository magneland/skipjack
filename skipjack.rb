#!/usr/bin/env ruby

require 'find'
require 'tempfile'
require 'fileutils'

def find_files(base_path, skip_message)
  Find.find(base_path) do |path|
    if FileTest.directory?(path)
      if File.basename(path)[0] == '.'
        Find.prune
      else
        next
      end
    else
      next if %r{/vendor/bundle/} =~ path
      next if %r{/gems/} =~ path
      if %r{/test/.*_test\.rb$} =~ path
        process(path, skip_message)
      end
    end
  end
end

def rewrite(line, skip_message)
  if %r{^(\s*)(def test_[\w!]+[!?=]?)(\s*)$} =~ line
    return $1 + $2 + "; skip('#{skip_message}')" + $3
  else
    return line
  end
end

def process(path, skip_message)
  puts "processing #{path}"
  temp_file = Tempfile.new('strip_out_tests')
  begin
    File.open(path, 'r') do |file|
      file.each_line do |line|
        temp_file.puts rewrite(line, skip_message)
      end
    end
    temp_file.close
    FileUtils.mv(temp_file.path, path)
  ensure
    temp_file.close
    temp_file.unlink
  end
end

def main
  if ARGV.size != 2
    $stderr.puts "usage: #{$0} <project_base_path> <your_custom_message>"
    exit 1
  end
  base_path = ARGV[0]
  skip_message = ARGV[1]

  find_files(base_path, skip_message)
end

main
