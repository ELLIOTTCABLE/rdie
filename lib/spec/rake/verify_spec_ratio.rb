module Spec
  module Rake
    
    # A task that can verify that the ratio of (lines of spec)
    # over (lines of code) doesn't drop below a certain threshold.
    # It should be run after running Spec::Rake::SpecTask.
    class VerifySpecRatioTask < ::Rake::TaskLib
      # Name of the task. Defaults to :verify_spec_ratio
      attr_accessor :name
      
      # Glob pattern to match code files. (default is '**/*.rb')
      # Automatically excludes everything matching +spec_pattern+
      attr_accessor :pattern
      
      # Glob pattern to match spec files. (default is 'spec/**/*_spec.rb')
      attr_accessor :spec_pattern
      
      # Whether or not to output details. Defaults to true.
      attr_accessor :verbose
      
      # The threshold value (in decimal value) for ratio. If the
      # actual ratio is not above this value, the task will raise an
      # exception. The ratio is devised as LoS/LoC, so values above 1
      # mean expressive specs, while values below one mean weak specs.
      attr_accessor :ratio
      
      def initialize(name=:verify_spec_ratio)
        @name = name
        @pattern = '**/*.rb'
        @spec_pattern = 'spec/**/*_spec.rb'
        @verbose = true
        yield self if block_given?
        raise "Ratio must be set" if @ratio.nil?
        define_task
      end
      
      def define_task
        desc "Verify that spec-ratio is at least #{@ratio}%"
        task @name do
          loc = 0
          los = 0
          
          code_files = Dir[@pattern]
          spec_files = Dir[@spec_pattern]
          
          code_files.each do |code_file|
            next if spec_files.include? code_file
            code = File.open(code_file)
            
            code.each_line do |line|
              line.gsub! /#(.*)/, '' # Get rid of all comments
              line.gsub! /\s/, '' # Get rid of all whitespace
              loc += 1 unless line.empty?
            end
          end
          
          spec_files.each do |spec_file|
            spec = File.open(spec_file)
            
            spec.each_line do |line|
              line.gsub! /#(.*)/, '' # Get rid of all comments
              line.gsub! /\s/, '' # Get rid of all whitespace
              los += 1 unless line.empty?
            end
          end
          
          ratio = (los.to_f / loc.to_f)
          
          puts "Spec-ratio: #{los}/#{loc} (#{ratio.to_s[0..3]}, expected >=: #{@ratio})" if @verbose
          raise "Spec-ratio must be above #{@ratio} but was #{ratio.to_s[0..3]}" if ratio < @ratio
          raise "Your spec-ratio file pattern matched no files" if loc == 0
          raise "Your spec-ratio specfile pattern matched no files" if los == 0
        end
      end
    end
    
  end
end