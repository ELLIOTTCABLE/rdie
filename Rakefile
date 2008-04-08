require 'rubygems'
Gem.clear_paths
Gem.path.unshift(File.join(File.dirname(__FILE__), "gems"))

require 'rake'
require 'rake/rdoctask'
require 'rake/testtask'
require 'spec/rake/spectask'
require 'spec/rake/verify_rcov'
require 'fileutils'
require 'merb-core'
require 'rubigen'
include FileUtils

# Load the basic runtime dependencies; this will include 
# any plugins and therefore plugin rake tasks.
init_env = ENV['MERB_ENV'] || 'rake'
Merb.load_dependencies(:environment => init_env)
     
# Get Merb plugins and dependencies
Merb::Plugins.rakefiles.each { |r| require r } 

desc "start runner environment"
task :merb_env do
  Merb.start_environment(:environment => init_env, :adapter => 'runner')
end

# Runs specs, generates rcov, and opens rcov in your browser.

Spec::Rake::SpecTask.new('rcov') do |t|
  t.spec_opts = ["--format", "specdoc", "--colour"]
  t.spec_files = Dir['spec/**/*_spec.rb'].sort
  t.libs = ['lib', 'server/lib' ]
  t.rcov = true
  t.rcov_dir = :meta / :coverage
end
task(:open_rcov) { system 'open "meta/coverage/index.html"' }
RCov::VerifyTask.new(:verify_rcov) do |t|
  t.threshold = 95.9
  t.index_html = 'meta/coverage/index.html'
end

desc 'Check everything over before commiting'
task :aok => [:rcov, :open_rcov, :verify_rcov]