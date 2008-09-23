#

module ActiveRecord
  module Validations
    module ClassMethods
      def validates_as_email (*params)
        configuration = {}
        validates_each(params, configuration) { |record, field, value|
          next if value.nil? or value.empty?
          begin
            address = TMail::Address.parse(value)
          rescue
            record.errors.add(field, "is not a valid email")
          end
        }
      end
    end
  end
end
