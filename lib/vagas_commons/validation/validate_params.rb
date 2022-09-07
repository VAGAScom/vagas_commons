# frozen_string_literal: true

require_relative 'validation_instance'

module VagasCommons::ValidateParams
  extend ActiveSupport::Concern
  include VagasCommons::ValidationInstance

  attr_reader :valid_params

  def validate_params
    action = params['action'].to_sym
    block = self.class.defined_validations[action]

    validation = get_validation_instance(block || VagasCommons::BasicSchema)

    validated = validation.call(params.to_unsafe_h)

    unless validated.success?
      render_error(validated.errors.to_h, 412)
      return false
    end
    @valid_params = validated.to_h
  end

  class << self; attr_accessor :defined_validations; end

  module ClassMethods
    def defined_validations
      @defined_validations || {}
    end

    def define_validation(action, &block)
      (@defined_validations ||= {})[action] = block
    end
  end
end
