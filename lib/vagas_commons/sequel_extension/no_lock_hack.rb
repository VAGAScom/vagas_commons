# frozen_string_literal: true

module VagasCommons::NoLockHack
  def load_hack
    Sequel::Model.db.extend_datasets do
      def join_clause_sql_append(sql, jclass)
        super
        sql << ' WITH (NOLOCK)' unless jclass.table.is_a?(Sequel::Dataset)
      end
    end
    Sequel::Model.db.send(:reset_default_dataset)
  end
end
