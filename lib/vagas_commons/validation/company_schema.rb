# frozen_string_literal: true

class VagasCommons::CompanySchema < Dry::Validation::Schema
  configure do |config|
    config.messages = :i18n
  end

  define! do
    required(:empresa_id).filled(:int?)
  end
end
