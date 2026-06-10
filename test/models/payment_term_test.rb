require 'test_helper'

class PaymentTermTest < ActiveSupport::TestCase
  test 'requires name' do
    pt = PaymentTerm.new(description: 'x')
    assert_not pt.valid?
    assert_includes pt.errors[:name], "can't be blank"
  end

  test 'name must be unique' do
    PaymentTerm.create!(name: 'unique-test')
    dup = PaymentTerm.new(name: 'unique-test')
    assert_not dup.valid?
    assert_includes dup.errors[:name], 'has already been taken'
  end

  test 'active scope excludes inactive rows' do
    assert_includes PaymentTerm.active, payment_terms(:paid_on_completion)
    assert_not_includes PaymentTerm.active, payment_terms(:inactive_term)
  end

  test 'ordered scope sorts by name' do
    names = PaymentTerm.ordered.pluck(:name)
    assert_equal names.sort, names
  end
end
