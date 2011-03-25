#                                                                -*- ruby -*-

Gem::Specification.new do |s|

  s.name             = 'grinc'
  s.version          = '0.1.1'
  s.date             = '2011-03-25'
  s.summary          = 'Command line include file preprocessor'
  s.authors          = ['Brian M. Clapper']
  s.license          = 'BSD'
  s.email            = 'bmc@clapper.org'
  s.homepage         = 'http://software.clapper.org/grinc'

  s.description      = <<-ENDDESC
grinc runs an include file preprocessor on one or more files, writing the
result to an output file (or standard output).
ENDDESC

  s.add_dependency('grizzled-ruby', '>= 0.1.4')

  # = MANIFEST =
  s.files            = Dir.glob('[A-Z]*')
  s.files           += Dir.glob('*.gemspec')
  s.files           += Dir.glob('lib/**/*')
  s.files           += Dir.glob('bin/**/*')
  s.files           += Dir.glob('man/**/*.[0-9]')
  s.files           += Dir.glob('src-man/**/*')


  # = MANIFEST =
  s.executables      = ['grinc']

end


