# frozen_string_literal: true

class PasswordCompositionValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add(attribute, 'has too many repeated characters') if too_many_repeating_characters?(value)
    record.errors.add(attribute, 'has too many sequential characters') if sequential_characters?(value)
    record.errors.add(attribute, 'has too many sequential characters') if reverse_sequential_characters?(value)
  end

  private

  def too_many_repeating_characters?(value)
    /(.)\1{3,}/i.match?(value)
  end

  def sequential_characters?(value)
    return false if value.blank?

    insensitive_value = value.downcase

    # Check for sequential (i.e. 'abcd', '1234')
    insensitive_value.each_char.slice_when { |a, b| a.succ != b }.filter_map { |c| c.join if c.size >= 4 }.present?
  end

  def reverse_sequential_characters?(value)
    return false if value.blank?

    insensitive_value = value.downcase

    # Check for reverse sequential (i.e. 'dcba', '4321')
    insensitive_value.each_char.with_index do |char, index|
      return true if reverse_sequential_present?(insensitive_value, char, index)
    end

    false
  end

  def reverse_sequential_present?(value, char, index)
    value[index + 1]&.ord == char.ord - 1 && value[index + 2]&.ord == char.ord - 2 &&
      value[index + 3]&.ord == char.ord - 3
  end
end
