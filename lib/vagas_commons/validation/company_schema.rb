# frozen_string_literal: true

class VagasCommons::CompanySchema < Dry::Validation::Contract
  config.messages.backend = :yaml

  schema do
    required(:empresa_id).filled(:int?)
  end
end
