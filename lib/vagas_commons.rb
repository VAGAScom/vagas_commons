# frozen_string_literal: true

require 'vagas_commons/version'

require 'logger'
require 'dry-configurable'

require 'vagas_commons/validation' if defined?(Rails) && defined?(Dry::Validation)
require 'vagas_commons/sequel_extension' if defined?(Sequel)
require 'vagas_commons/requests' if defined?(Typhoeus)
require 'vagas_commons/serializers' if defined?(ActiveModel::Serializer)

module VagasCommons
  extend Dry::Configurable

  setting :logger, Logger.new(STDOUT)
  setting :request do
    setting :user_agent, 'gem VAGAS Commons'
  end
  setting :requests do
    setting :max_concurrent_requests, 10
  end

  def self.logger
    config.logger
  end
end
