# frozen_string_literal: true

# Classe que representa uma requisicao nula, para nao precisar tratar valores nulos
class VagasCommons::EmptyRequest
  include VagasCommons::BaseRequest

  def service_uri
    raise 'Invalid request'
  end

  def as_object(_body, _response)
    nil
  end

  def status
    404
  end

  def success?
    false
  end
end
