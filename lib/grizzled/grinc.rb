#!/usr/bin/env ruby
#
# See the man page or http://software.clapper.org/grizzled-ruby/grinc/
# for documentation.
#--
# This software is released under a BSD license, adapted from
# http://opensource.org/licenses/bsd-license.php
#
# Copyright (c) 2011, Brian M. Clapper
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
# * Redistributions of source code must retain the above copyright notice,
#   this list of conditions and the following disclaimer.
#
# * Redistributions in binary form must reproduce the above copyright
#   notice, this list of conditions and the following disclaimer in the
#   documentation and/or other materials provided with the distribution.
#
# * Neither the names "clapper.org", "Grizzled Ruby Library", nor the
#   names of its contributors may be used to endorse or promote products
#   derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
# IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
# THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#++

require 'optparse'
require 'rubygems'
require 'grizzled/fileutil/includer'

include Grizzled::FileUtil

module Grizzled

  module Grinc

    # -----------------------------------------------------------------------
    # Constants
    # -----------------------------------------------------------------------

    DEFAULT_MAX_NEST = 100
    PROGRAM_NAME = 'grinc'
    THIS_GEM_PATH = 'grizzled/grinc'

    # -----------------------------------------------------------------------
    # Classes
    # -----------------------------------------------------------------------

    class Parameters
      attr_reader :output, :max_nesting, :input_paths

      def initialize(options_hash, argv)
        @options = options_hash
        @options[:max_nesting] = options_hash[:max_nesting] || DEFAULT_MAX_NEST
        @options[:input_paths] = argv.length == 0 ? nil : argv
      end

      def method_missing(m, *args, &block)
        @options[m]
      end

      def to_s
        inspect
      end
    end

    class UsageError < StandardError; end

    class GrincRunner
      def initialize
      end

      def run
        begin
          params = parse_params
          if params.show_version
            show_version_only
          else
            run_includer params
          end

        rescue UsageError
          return 1

        rescue Interrupt
          $stderr.puts("\nAborted")
          return 1

        rescue
          $stderr.puts("#{PROGRAM_NAME}: #{$!}")
          return 1

        else
          return 0
        end
      end

      private

      def show_version_only
        gem_spec = Gem.searcher.find(THIS_GEM_PATH)
        if not gem_spec
          raise StandardError.new("Can't find Gem specification for path \"" +
                                  "#{THIS_GEM_PATH}\".")
        end
        puts("#{PROGRAM_NAME}, version #{gem_spec.version}. " +
             "#{gem_spec.homepage}")
      end

      def run_includer(params)
        out = params.output.nil? ? $stderr : File.open(params.output, 'w')

        if params.input_paths.nil?
          process_include($stdin, out, params.max_nesting)
        else
          params.input_paths.each do |f|
            process_include(File.open(f), out, params.max_nesting)
          end
        end
      end

      def parse_params
        options_hash = {}
        error = nil
        option_parser = OptionParser.new do |opts|
          opts.program_name = PROGRAM_NAME
          opts.banner = "Usage: #{opts.program_name} [OPTIONS] inputfile ..."
          opts.separator ''
          opts.separator 'OPTIONS:'

          opts.on('-o FILE', 'Output file. Default: standard output.') do |f|
            options_hash[:output] = f
          end

          opts.on('-n', '--nesting n',
                  "Max nesting. Default: #{DEFAULT_MAX_NEST}") do |n|
            if n !~ /^[0-9]+$/
              error = "Non-numeric parameter \"#{n}\" to -n option."
            end
            options_hash[:max_nesting] = n.to_i
          end

          opts.on('-V', '--version', 'Display version number and exit.') do
            options_hash[:show_version] = true
          end
        end

        begin
          option_parser.parse!(ARGV)
        rescue OptionParser::InvalidOption => ex
          error = ex.to_s
        end

        if error
          $stderr.puts(error) unless error.nil?
          option_parser.display
          raise UsageError.new
        end

        if ARGV.length == 0
          options_hash[:input_files] = nil
        else
          options_hash[:input_files] = ARGV
        end

        Parameters.new(options_hash, ARGV)
      end

      private

      def process_include(input_file, output_file, max_nesting = 100)
        Includer.new(input_file, :max_nesting => max_nesting).each do |line|
          output_file.write(line)
        end
      end
    end

  end # module Grinc
end # module Grizzled


