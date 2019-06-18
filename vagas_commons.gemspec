# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vagas_commons/version'

Gem::Specification.new do |spec|
  spec.name          = 'vagas_commons'
  spec.version       = VagasCommons::VERSION
  spec.authors       = ['Adriano Dadario']
  spec.email         = ['adriano.dadario@vagas.com.br']

  spec.summary       = 'O propósito desta gem é concentrar as modificações
    que fazemos em comum em diversos projetos.'
  spec.description   = 'Muita repetição tem acontecido em diversos projetos
    com inclusão de dry-validation e necessidades do sequel para tratamento
    do SQLServer, desta maneira a simples inclusão dessa gem permite que esse
    processo seja transparente ao projetos.'
  spec.homepage      = 'https://github.com/VAGAScom/vagas_commons'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = ''
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'dry-configurable'
  spec.add_dependency 'dry-validation', '~> 0.13.0'
  spec.add_dependency 'oj'
  spec.add_dependency 'oj_mimic_json'
  spec.add_dependency 'typhoeus'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop'
end
