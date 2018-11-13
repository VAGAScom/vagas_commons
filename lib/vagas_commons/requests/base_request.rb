# frozen_string_literal: true

# Modulo que faz o tratamento de resposta das requisicoes.
# Deve ser estendida com as informacoes extras de service_uri e as_object
module VagasCommons::BaseRequest
  attr_reader :object, :response, :healthcheck
  HTTP_UNPROCESSABLE_ENTITY = 422

  ##
  # Metodos necessarios serem implementados para executar a requisicao

  ##
  # Implementacao necessaria para indicar qual o host que deve ser alcancado
  def host
    raise MethodMissingError
  end

  ##
  # Implementacao necessaria para indicar qual o path da URL
  def service_path
    raise MethodMissingError
  end

  ##
  # Implementacao necessaria para tratamento do corpo da requisicao para
  # transformar em um objeto, por padrao o body vem um hash
  # O parametro +_body+ representa um json em formato objeto hash do retorno
  # da API
  # O parametro +_response+ e o objeto de retorno da requisicao
  def as_object(_body, _response)
    raise MethodMissingError
  end

  ##
  # Metodos que podem ser implementados para comportar os dados que serao
  # enviados
  def parameters
    nil
  end

  def request_body
    nil
  end

  def method
    :get
  end

  def headers
    {}
  end

  def user_agent
    VagasCommons.config.request.user_agent
  end

  def status
    response.code
  end

  def success?
    response.success?
  end

  ##
  # Metodos usados internamente para montar requisicao
  def service_uri
    "#{host}#{service_path}"
  end

  def request
    Typhoeus::Request
      .new(service_uri, request_options).tap do |req|
        handle_request(req)
      end
  end

  def request_healthcheck
    request = Typhoeus::Request.new("#{host}/healthcheck", timeout: 5)
    @healthcheck = {}
    request.on_complete do |response|
      healthcheck[:status] = response.code
      healthcheck[:time] = response.total_time
    end
    request
  end

  private

  def request_options
    { method: method, params: parameters, body: request_body, headers: http_header }
  end

  ##
  # Metodos disponiveis para recuperar as informacoes
  def http_body
    body = response.body

    if body.empty?
      log_error('resposta-sem-conteudo')
      return { error: 'resposta-sem-conteudo', code: response.code }
    end
    parse_json(body)
  rescue IOError => e
    log_error(e.message, code: HTTP_UNPROCESSABLE_ENTITY)
    { error: e.message, code: HTTP_UNPROCESSABLE_ENTITY }
  end

  def handle_request(request)
    request.on_complete do |response|
      @response = response
      if response.success?
        @object = as_object(http_body, response)
      else
        log_error('HTTP-request-failed')
      end
    end
  end

  def parse_json(body)
    if defined?(Oj)
      Oj.load(body, symbol_keys: true)
    else
      JSON.parse(body)
    end
  rescue Oj::ParseError
    raise IOError, 'invalid-json-result-format'
  rescue JSON::ParserError
    raise IOError, 'invalid-json-result-format'
  end

  def log_error(error, code: response&.code)
    VagasCommons.logger.error(error: error,
                              code: code,
                              url: service_uri,
                              options: request_options)
  end

  def http_header
    { 'User-Agent' => user_agent }.merge(headers || {})
  end
end
