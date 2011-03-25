#                                                                  -*- ruby -*-
#
# NOTE: Man pages use the 'ronn' gem. http://rtomayko.github.com/ronn/

require 'rake/clean'
require 'pathname'

PACKAGE = 'grinc'
GEMSPEC = "#{PACKAGE}.gemspec"
RUBY_FILES = FileList['bin/*']
MAN_OUT_DIR = 'man'
GH_PAGES_DIR = File.join('..', 'gh-pages')
MAN_PUBLISH_DIR = File.join(GH_PAGES_DIR, 'man')
MAN_SOURCE_DIR = 'src-man'
MAN_SOURCES = FileList[File.join(MAN_SOURCE_DIR, '*.md')]

MAN_PAGES = MAN_SOURCES.map do |m|
  if m =~ %r{#{MAN_SOURCE_DIR}/([^.]+)\.([0-9])\.md$}
    [File.join(MAN_OUT_DIR, "man#{$2}", "#{$1}.#{$2}.html"),
     File.join(MAN_OUT_DIR, "man#{$2}", "#{$1}.#{$2}")]
  else
    raise StandardError.new("#{m} doesn't look like a man page source.")
  end
end.flatten

def load_gem(spec)
  eval File.open(spec).readlines.join('')
end

def gem_name(spec)
  gem = load_gem(spec)
  "#{PACKAGE}-#{gem.version.to_s}.gem"
end

GEM = gem_name(GEMSPEC)
CLEAN << [MAN_OUT_DIR, GEM]

# ---------------------------------------------------------------------------
# Rules
# ---------------------------------------------------------------------------

def man_source
  Proc.new do |man_target|
    if man_target =~ %r{#{MAN_OUT_DIR}/man[0-9]/(.*\.[0-9])}
      File.join("src-man", $1 + ".md")
    elsif man_target =~ %r{#{MAN_OUT_DIR}/man[0-9]/(.*\.[0-9].html)}
      File.join("src-man", $1 + ".md")
    else
      raise StandardError.new("Can't find source for man page #{man_target}")
    end
  end
end

# Make man/man?/thing.? from src-man/thing.?/md
rule %r{#{MAN_OUT_DIR}/man[0-9]/.*\.[0-9]} => [man_source, 'Rakefile'] do |t|
  mkdir_p File.dirname(t.name)
  sh "ronn --roff --pipe #{t.source} >#{t.name}"
end

# Make man/man?/thing.?.html from src-man/thing.?/md
rule %r{#{MAN_OUT_DIR}/man[0-9]/.*\.[0-9]\.html} => [man_source, 'Rakefile'] do |t|
  mkdir_p File.dirname(t.name)
  sh "ronn --html --pipe #{t.source} >#{t.name}"
end


# ---------------------------------------------------------------------------
# Tasks
# ---------------------------------------------------------------------------

task :default => :build

desc "Build everything"
task :build => [:gem, :doc]

desc "Synonym for 'build'"
task :all => :build

desc "Build the gem (#{GEM})"
task :gem => GEM

file GEM => RUBY_FILES + ['Rakefile', GEMSPEC] do |t|
  require 'rubygems/builder'
  if !defined? Gem
    raise StandardError.new("Gem package not defined.")
  end
  spec = eval File.new(GEMSPEC).read
  Gem::Builder.new(spec).build
end  

desc "Build the documentation, locally"
task :doc => :man

task :man => MAN_PAGES + ['Rakefile']

desc "Install the gem"
task :install => :gem do |t|
  require 'rubygems/installer'
  puts("Installing from #{GEM}")
  Gem::Installer.new(GEM).install
end

desc "Publish the gem"
task :publish => :gem do |t|
  sh "gem push #{GEM}"
end

desc "Publish the docs. Not really of use to anyone but the author"
task :pubdoc => [:pubman, :pubchangelog]

desc "Publish the man pages. Not really of use to anyone but the author"
task :pubman => :man do |t|
  target = Pathname.new(MAN_PUBLISH_DIR).expand_path.to_s
  cd MAN_OUT_DIR do
    mkdir_p target
    Dir['**/*.html'].each do |m|
      cp m, target
    end
  end
end

desc "Synonym for 'pubchangelog'"
task :changelog

desc "Publish the change log. Not really of use to anyone but the author"
task :pubchangelog do |t|
  File.open(File.join(GH_PAGES_DIR, 'CHANGELOG.md'), 'w') do |f|
    f.write <<EOF
---
title: Change Log for grinc
layout: default
---

EOF
    f.write File.open('CHANGELOG.md').read
    f.close
  end
end

task :pub

desc "Alias for 'docpub'"
task :docpub => :pubdoc
