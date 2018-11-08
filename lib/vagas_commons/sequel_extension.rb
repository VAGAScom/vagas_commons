# frozen_string_literal: true

require_relative 'sequel_extension/no_lock_table_plugin'
require_relative 'sequel_extension/no_lock_hack'

module VagasCommons::Sequel
  extend VagasCommons::NoLockHack

  def self.init
    Sequel::Model.plugin :no_lock_table
    load_hack
  end
end
