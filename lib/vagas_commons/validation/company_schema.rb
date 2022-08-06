# frozen_string_literal: true

class VagasCommons::CompanySchema < Dry::Validation::Contract
  config.messages.backend = :i18n

  schema do
    required(:empresa_id).filled(:int?)
  end
end
