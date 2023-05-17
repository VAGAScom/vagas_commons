# Códigos comuns - VAGAS

Esta gem tem a finalidade de permitir a distribuição de código comum em diversos
projetos, evitando a duplicação dos mesmos e a manutenabilidade.

O projeto depende de uso de gems externas que não são carregadas diretamente
nesta gem, mas a verificação da mesma ocorre quando requerer o código código da
gem.


## Instalação

Adicione essa senha no Gemfile da sua aplicação

```ruby
gem 'vagas_commons', github: 'VAGAScom/vagas_commons'
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
# Pode indicar a inicializar por essa linha de comando
VagasCommons::Sequel.init
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

VagasCommons::Sequel.init
```

### Requisições HTTP Externas

Esta funcionalidade disponibiliza uma estrutura para criar classes responsáveis por requisições HTTP e objetos usando a ```gem typhoeus```.
Também para simplificar as multiplas requisições HTTPs fazendo em paralelo usando o recurso Hydra da ```gem typhoeus```.

Para utilizar:

```ruby
# Criar uma classe que responda pelas informacoes de requisicao
class MyServiceRequest
  include VagasCommons::BaseRequest

  # Implementar os metodos necessarios para identificar os dados da requisicao
  def host
    'http://subdomain.domain.com'
  end

  def service_path
    '/v1/servico'
  end

  def as_object(body, response)
    # Como transformar o retorno em objeto?
    MeuObjeto.new(body)
  end

  # Opcionalmente voce pode indicar informacoes extras

  # Qual o User-Agent da requisicao.
  # Também pode ser indicado na configuracao da gem (ver mais abaixo)
  def user_agent
    'Minha API'
  end

  # Se deseja pssar parametros via URL, pode ser indicado um HASH
  def parameters
    { user: 'name', passwd: 'changeit' }
  end

  # Enviar um corpo numa requisicao do tipo POST
  def request_body
    { user: 'name', passwd: 'changeit' }
  end

  # Definir o metodo de envio da requisicao
  def method
    :get
  end

  # Adicionar informacoes extras no Header
  def headers
    { 'Content-type' => 'application/json' }
  end

  # Informar opções extras suportadas por uma requisição do Typhoeus
  #
  # Exemplo de algumas opções permitidas:
  def options
    { followlocation: true,
      ssl_verifypeer: true,
      ssl_verifyhost: 2,
      verbose: true }
  end

  # Define a rota para verificação do status do host informado na classe.
  # Valor padrão é "healthcheck"
  def healthcheck_path
    'health_status'
  end
end
```

Para executar as chamadas utilizando a estrutura, basta compor as requisições

```ruby
my_requests = {
  req1: MyServiceRequest.new,
  req2: MyServiceRequest.new
}

# Passa os objetos de requisicoes
requests = VagasCommons::Requests.new(my_requests)

# Execucao em paralelo acontecendo
requests.run

# Recupera cada requisicao pela chave informada
request = requests[:req1]

# Algumas informacoes que podem ser obtidas da requisicao

request.object
request.http_body
request.status
request.success?
request.response
```

Se você quiser chamar uma URL de verificação de status do host definido na classe `MyServiceRequest`,
basta executar:

```ruby
requests.run_healthcheck
```

### Serializers

Caso possua classes de serializer, utilizando a ```gem active_model_serializers```, é possível remover os atributos que tenham valor `nil`, incluindo o módulo ```VagasCommons::NullAttributesRemover```, da seguinte maneira:

```ruby
class MyModelSerializer < ActiveModel::Serializer
  # Incluir módulo para remover atributos com valor nil
  include VagasCommons::NullAttributesRemover

  # Atributos do serializer
  attributes :name, :email
end

render json: MyModel.new('John Doe', nil),
       serializer: MyModelSerializer

# Resultado:
# => { "name": "John Doe" }
```

### Configurações disponíveis

Algumas informações podem ser configuradas para uso da gem:

```ruby
module VagasCommons
  extend Dry::Configurable
   
  # Indicar para uso do logger por outro meio de saída
  setting :logger, default: Logger.new($stdout)
  
  # Indicar qual o agent de requisições HTTP padrão
  setting :request do
    setting :user_agent, default: 'Um novo agent'
  end
  
  # Quantidade máxima de requisições HTTP em paralelo
  setting :requests do
    setting :max_concurrent, default: 10
  end

  def self.logger
    config.logger
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/vagas/vagas_commons. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the VagasCommons project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/vagas/vagas_commons/blob/master/CODE_OF_CONDUCT.md).
