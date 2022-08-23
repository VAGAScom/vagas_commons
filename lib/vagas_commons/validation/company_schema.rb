# frozen_string_literal: true

class VagasCommons::CompanySchema < Dry::Validation::Contract
  config.messages.backend = :yaml

  params do
    required(:empresa_id).value(:integer)
  end
end
