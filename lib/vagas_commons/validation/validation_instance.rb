# frozen_string_literal: true

module VagasCommons::ValidationInstance
  def get_validation_instance(instance)
    raise 'Invalid Validation Schema' if instance.call.superclass.to_s != 'Dry::Validation::Contract'

    instance.call.new
  end
end
