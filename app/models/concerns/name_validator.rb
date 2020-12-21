# frozen_string_literal: true

class NameValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add(attribute, 'contains invalid characters') unless name_valid?(value)
  end

  private

  def name_valid?(value)
    /^[\w'.-]+$/.match?(value)
  end
end
