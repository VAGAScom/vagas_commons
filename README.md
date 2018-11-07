# Códigos comuns - VAGAS

Esta gem tem a finalidade de permitir a distribuição de código comum em diversos
projetos, evitando a duplicação dos mesmos e a manutenabilidade.

O projeto depende de uso de gems externas que não são carregadas diretamente
nesta gem, mas a verificação da mesma ocorre quando requerer o código código da
gem.


## Instalação

Adicione essa senha no Gemfile da sua aplicação

```ruby
gem 'vagas_commons', git: 'https://bitbucket.org/vagas/vagas_commons'
```

E então execute:

    $ bundle

Ou instale diretamente:

    $ gem install vagas_commons

## Uso

Existem vários recursos disponíveis nesta gem, para cada um, uma forma diferente
de uso é aplicado

### Validação

Existem uma forma de validação utilizando a ```gem dry-validation```, esta gem tem uma forma de validação para parametros de entrada.

Para uso desse recurso, a aplicação dever estar usando a ```gem Rails```
e no controller existe a possibilidade de utilizar a validação seguindo a forma:

```ruby
class MyController < ApplicationController
  # Incluir chamada para definir métodos de validação
  include VagasCommons::ValidateParams

  # Executar a validação antes de cada action
  before_action :validate_params

  # Definir regras da validação para cada action
  define_validation(:index) do
    # Uso do dry-validation, o BasicSchema apenas indica que é preciso usar
    # internacionalização, pode usar também o CompanySchema que requer o
    # parametro empresa_id
    Dry::Validation.Params(VagasCommons::BasicSchema) do
      required(:id).filled(:int?, gt?: 0)
    end
  end
  def index
    # O hash valid_params mantém apenas os parametros declarados e validos pelo
    # dry-validation
    valid_params.inspect
  end

end
```

### Sequel Extension

Quando utilizamos o Sequel com MSSql Server, é preciso definir alguns regras
para que ele utilize a instrução WITH(NOLOCK) nas operações de consultas.

Essas regras são carregadas através de extensões e comandos incluídos no Sequel

Para habilitar essa operação, é preciso estar usando a ```gem Sequel``` e logo após a
inicialização do Sequel executar o comando:

```ruby
VagasCommons::Sequel.load
```

Por exemplo, numa aplicação Rails, você pode ter um arquivo na pasta
```
config/initializers/sequel_init.rb
```
com as instruções:

```ruby
require 'sequel'

Sequel.split_symbols = true

Sequel::Model.db.extension(:pagination)
Sequel::Model.plugin :validation_helpers
Sequel::Model.require_valid_table = false
Sequel::Model.db.logger = Rails.logger

VagasCommons::Sequel.load
```

### Requisições HTTP Externas

Esse disponibiliza uma estrutura para criar classes responsáveis por
requisições HTTP e objetos usando a ```gem typhoeus```.
Também para simplificar as multiplas requisições HTTPs fazendo em paralelo usando o recurso Hydra da ```gem typhoeus```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/vagas/vagas_commons. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the VagasCommons project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/vagas/vagas_commons/blob/master/CODE_OF_CONDUCT.md).
