require 'nokogiri'

module SaxStream
  module Internal
    class XmlBuilder
      def initialize(options = {})
        @encoding = options[:encoding] || 'UTF-8'
      end

      def build_xml_for(object, parent = nil)
        mappings = object.mappings

        in_sub_object = has_doc?
        @doc ||= build_doc

        base = add_base_element(@doc, parent || @doc, object)

        object.mappings.each do |mapping|
          add_mapping(@doc, base, object, mapping)
        end

        in_sub_object ? base : @doc.to_xml
      end

      private

        def has_doc?
          !!@doc
        end

        def build_doc
          @doc = Nokogiri::XML::Document.new
          @doc.encoding = @encoding
          @doc
        end

        def add_base_element(doc, parent, object)
          base = doc.create_element(object.node_name)
          parent << base
          base
        end

        def add_mapping(doc, base, object, mapping)
          parent = mapping.find_or_insert_parent_node(doc, base)
          mapping.update_parent_node(self, doc, parent, object)
        end
    end
  end
end