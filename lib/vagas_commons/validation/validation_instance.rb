# frozen_string_literal: true

module VagasCommons::ValidationInstance
  def get_validation_instance(instance)
    get_instance = set_validation_instance(instance)
    raise 'Invalid Validation Schema' if get_instance.nil?

    get_instance
  end

  def set_validation_instance(instance)
    begin
      # se responder ao método, provavelmente é um esquema de validação
      if instance.call.respond_to?(:ancestors) && instance.call.ancestors.include?(Dry::Validation::Contract)
        return instance.call.new
      end

      # se não responder ao método, provavelmente é um contrato de validação
      if instance.call.respond_to?(:ancestors) == false && instance.call.class.ancestors.include?(Dry::Validation::Contract)
        return instance.call
      end
      nil
    rescue RuntimeError, NoMethodError, StandardError
      raise 'Invalid Validation Schema'
    end
  end
end
