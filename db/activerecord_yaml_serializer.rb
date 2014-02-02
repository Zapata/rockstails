require 'active_support/core_ext/class/attribute'

module ActiveModel
  # == Active Model YAML Serializer
  module Serializers
    module YAML
      extend ActiveSupport::Concern
      include ActiveModel::Serialization

      included do
        extend ActiveModel::Naming

        class_attribute :include_root_in_json
        self.include_root_in_json = false
      end

      # Same thing as as_json, but returns yaml instead of a hash (unless you include the as_hash:true option)
      def as_yaml(options = nil)
        as_hash = !options.nil? && options.delete(:as_hash)
        hash = serializable_hash(options)

        if include_root_in_json
          custom_root = options && options[:root]
          hash = { custom_root || self.class.model_name.element => hash }
        end

        as_hash ? hash : hash.to_yaml
      end
      
      def from_yaml(yaml)
        hash = YAML.load(yaml)
        hash = hash.values.first if include_root_in_json
        self.attributes = hash
        self
      end
    end
  end
end

class ActiveRecord::Base
  include ActiveModel::Serializers::YAML
end