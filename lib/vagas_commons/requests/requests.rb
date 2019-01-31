# frozen_string_literal: true

require 'forwardable'

# Classe encapsula todas as requisicoes do Typhoeus e executa conforme a chamada
class VagasCommons::Requests
  extend Forwardable

  attr_reader :requests
  def_delegators :requests, :map

  def initialize(requests = {})
    @requests = requests
  end

  def []=(key, requester)
    requests[key] = requester
  end

  def [](key)
    requests.fetch(key) { VagasCommons::EmptyRequest.new }
  end

  def run(max_concurrency: max_concurrent)
    return self if requests.empty?

    if requests.size == 1
      run_single
    else
      hydra = Typhoeus::Hydra.new(max_concurrency: max_concurrency)
      requests.each_pair { |_key, req| hydra.queue(req.request) }
      hydra.run
    end
    self
  end

  def run_single
    requester = requests.values.first
    requester.request.run
  end

  def run_healthcheck
    return :no_services if requests.empty?

    hydra = Typhoeus::Hydra.new(max_concurrency: max_concurrent)
    requests.each_pair { |_key, req| hydra.queue(req.request_healthcheck) }
    hydra.run
    requests.map { |key, req| [key, req.healthcheck] }.to_h
  end

  private

  def max_concurrent
    VagasCommons.config.requests.max_concurrent
  end
end
