# frozen_string_literal: true

class VagasCommons::BasicSchema < Dry::Validation::Schema
  configure do |config|
    config.messages = :i18n
  end
end
