# frozen_string_literal: true

# Classe encapsula todas as requisicoes do Typhoeus e executa conforme a chamada
class VagasCommons::Requests
  attr_reader :requests
  delegate :map, to: :requests

  def initialize(requests = {})
    @requests = requests
  end

  def []=(key, requester)
    requests[key] = requester
  end

  def [](key)
    requests.fetch(key, VagasCommons::EmptyRequest.new)
  end

  def run(max_concurrency: 10)
    return self if requests.empty?

    if requests.size == 1
      simple_run
    else
      hydra = Typhoeus::Hydra.new(max_concurrency: max_concurrency)
      requests.each_pair { |_key, req| hydra.queue(req.request) }
      hydra.run
    end
    self
  end

  def simple_run
    requester = requests.values.first
    requester.request.run
  end

  def run_healthcheck
    return :no_services if requests.empty?

    hydra = Typhoeus::Hydra.new(max_concurrency: 10)
    requests.each_pair { |_key, req| hydra.queue(req.request_healthcheck) }
    hydra.run
    requests.map { |key, req| [key, req.healthcheck] }.to_h
  end
end
