# frozen_string_literal: true

module Sequel::Plugins::NoLockTable
  # Modify the current model's dataset selection, if the model
  # has a dataset.
  def self.configure(model)
    model.instance_eval do
      self.dataset = dataset if @dataset
    end
  end

  module ClassMethods
    private

    def convert_input_dataset(dataset)
      super.nolock
    end
  end
end
