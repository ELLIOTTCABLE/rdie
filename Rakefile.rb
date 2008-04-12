require 'rubygems'
Gem.clear_paths
Gem.path.unshift(File.join(File.dirname(__FILE__), "gems"))

require 'rake'
require 'rake/rdoctask'
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

task :check_config do
  raise 'You need to copy config/database.yml.sample to config/database.yml, and add your data!' unless
    File.file? 'config/database.yml'
end

# Runs specs, generates rcov, and opens rcov in your browser.
namespace :rcov do
  Spec::Rake::SpecTask.new(:run) do |t|
    t.spec_opts = ["--format", "specdoc", "--colour"]
    t.spec_files = Dir['spec/**/*_spec.rb'].sort
    t.libs = ['lib', 'server/lib' ]
    t.rcov = true
    t.rcov_dir = :meta / :coverage
  end
  
  Spec::Rake::SpecTask.new(:plain) do |t|
    t.spec_opts = ["--format", "specdoc"]
    t.spec_files = Dir['spec/**/*_spec.rb'].sort
    t.libs = ['lib', 'server/lib' ]
    t.rcov = true
    t.rcov_opts = ['--exclude-only', '".*"', '--include-file', '^app,^lib']
    t.rcov_dir = :meta / :coverage
  end
  
  desc "Enforces coverage maintenance"
  RCov::VerifyTask.new(:verify) do |t|
    t.threshold = 100
    t.index_html = :meta / :coverage / 'index.html'
  end

  task :open do
    system 'open ' + :meta / :coverage / 'index.html' if PLATFORM['darwin']
  end
end

namespace :ditz do
  
  desc "Current issues summary"
  task :status do
    system 'ditz status'
  end
  task :todo do
    system 'ditz todo'
  end
  desc "Show recent issue activity"
  task :log do
    system 'ditz log'
  end
  
  desc "Generate issues to meta/issues"
  task :html do
    # `'d instead of system'd, because I don't want that output cluttering shit
    `ditz html meta/issues`
  end
  task :'html:open' do
    system 'open ' + :meta / :issues / 'index.html' if PLATFORM['darwin']
  end
  
  desc "Stage all issues to git before commiting"
  task :stage do
    system 'git-add bugs/'
  end
end

# Well that was a waste of time...
# Rake::RDocTask.new do |d|
#   d.main = "meta/docs/index.rdoc"
#   d.rdoc_files.include("app/**/*.rb", "lib/**/*.rb")
#   d.rdoc_dir = :meta / :documentation
# end

desc 'Check everything over before commiting'
task :aok => [:check_config, :'rcov:run', :'rcov:verify', :'ditz:stage', :'ditz:html', :'ditz:todo', :'ditz:status', :'rcov:open', :'ditz:html:open']
# desc 'Task run during continuous integration'
task :cruise => [:check_config, :'rcov:plain', :'ditz:html', :'rcov:verify']

# Tasks for systems
Dir[Merb.root / "systems" / "*"].each do |system|
  next unless File.directory? system
  system = File.basename(system)
  
  namespace system do
    namespace :rcov do
      Spec::Rake::SpecTask.new(:run) do |t|
        t.spec_opts = ["--format", "specdoc", "--colour"]
        t.spec_files = Dir[:systems / system / :spec /:**/ :'*_spec.rb'].sort
        t.libs = [:systems / system / :lib, 'lib', 'server/lib']
        t.rcov = true
        t.rcov_dir = :systems / system / :meta / :coverage
        t.rcov_opts = ['--exclude', '".*"', '--include-file', "'systems/#{system}'"]
      end
      
      desc "Enforces coverage maintenance"
      RCov::VerifyTask.new(:verify) do |t|
        t.threshold = 100
        t.index_html = :systems / system / :meta / :coverage / 'index.html'
      end

      desc "Open a browser window with the coverage report (Mac only)"
      task :open do
        system 'open ' + :systems / system / :meta / :coverage / 'index.html' if
          PLATFORM['darwin']
      end
    end
    
    desc 'Check everything over before commiting'
    task :aok => [:'rcov:run', :'rcov:verify', :'rcov:open']
  end
end