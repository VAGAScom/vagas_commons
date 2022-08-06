# frozen_string_literal: true

class VagasCommons::BasicSchema < Dry::Validation::Contract
  config.messages.backend = :i18n
  schema {}
end
