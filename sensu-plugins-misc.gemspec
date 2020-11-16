# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'date'
require_relative 'lib/sensu-plugins-mysql'

Gem::Specification.new do |s|
  s.authors                = ['Sensu-Plugins and contributors']
  # s.cert_chain             = ['certs/sensu-plugins.pem']
  s.date                   = Date.today.to_s
  s.description            = 'This plugin provides misc instrumentation
                              for monitoring and metrics collection.'
  s.email                  = '<nachum234@gmail.com>'
  s.executables            = Dir.glob('bin/**/*.rb').map { |file| File.basename(file) }
  s.files                  = Dir.glob('{bin,lib}/**/*')
  s.homepage               = 'https://github.com/nachum234/sensu-plugins-misc'
  s.license                = 'MIT'
  s.metadata               = { 'maintainer' => 'nachum234',
                               'development_status' => 'pause',
                               'production_status' => 'unstable - testing recommended',
                               'release_draft' => 'false',
                               'release_prerelease' => 'false' }
  s.name                   = 'sensu-plugins-misc'
  s.platform               = Gem::Platform::RUBY
  s.post_install_message   = 'You can use the embedded Ruby by setting EMBEDDED_RUBY=true in /etc/default/sensu'
  s.require_paths          = ['lib']
  s.required_ruby_version  = '>= 2.3.0'
  # s.signing_key            = File.expand_path(pvt_key) if $PROGRAM_NAME =~ /gem\z/
  s.summary                = 'Sensu plugins for Misc'
  s.test_files             = s.files.grep(%r{^(test|spec|features)/})
  s.version                = SensuPluginsMisc::Version::VER_STRING

  s.add_runtime_dependency 'inifile', '3.0.0'
  s.add_runtime_dependency 'ruby-mysql', '~> 2.9'
  s.add_runtime_dependency 'sensu-plugin', '~> 4.0'

end
