# frozen_string_literal: true

# Módulo que remove atributos que estão nulos na apresentação do JSON
#
# Ao ser incluído em uma classe que herda de [ActiveModel::Serializer], qualquer
# atributo que tenha valor nulo é removido do retorno ao renderizar como JSON.
module VagasCommons::NullAttributesRemover
  def serializable_hash(adapter_options = nil,
                        options = {},
                        adapter_instance = self.class.serialization_adapter_instance)
    hash = super
    hash.tap { |h| h.each { |key, value| hash.delete(key) if value.nil? } }
  end
end
