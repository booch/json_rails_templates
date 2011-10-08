require 'bundler'
Bundler::GemHelper.install_tasks


require 'rspec/core/rake_task'

desc 'Default: run specs'
task :default => :spec

desc 'Run specs'
RSpec::Core::RakeTask.new('spec') do |t|
  t.rspec_opts = ['--color', '--format progress']
  t.pattern = 'spec/**/*_spec.rb'
end

namespace 'spec' do
  desc 'Print out specs'
  RSpec::Core::RakeTask.new('docs') do |t|
    t.rspec_opts = ['--color', '--format documentation']
    t.pattern = 'spec/**/*_spec.rb'
  end
end

# Adapted from http://grosser.it/2011/10/04/rake-versionbumppatch-in-the-age-of-bundler-gemspecs/
rule /^version:bump:.*/ do |t|
  sh "git status | grep 'nothing to commit'" # ensure we are not dirty
  index = ['major', 'minor','patch'].index(t.name.split(':').last)
  file = 'lib/GEM_NAME/version.rb'

  version_file = File.read(file)
  old_version, *version_parts = version_file.match(/(\d+)\.(\d+)\.(\d+)/).to_a
  version_parts[index] = version_parts[index].to_i + 1
  new_version = version_parts * '.'
  File.open(file,'w'){|f| f.write(version_file.sub(old_version, new_version)) }

  sh "bundle && git add #{file} Gemfile.lock && git commit -m 'Bump version to #{new_version}'"
end
