require "test_helper"

class SalesEntryTest < ActiveSupport::TestCase
  def setup
    @goal = goals(:one)
    @sales_entry = SalesEntry.new(amount: 1000, method: 'direct', goal: @goal)
  end

  test "should be valid" do
    assert @sales_entry.valid?
  end

  test "amount should be present" do
    @sales_entry.amount = nil
    assert_not @sales_entry.valid?
  end

  test "amount should be positive" do
    @sales_entry.amount = 0
    assert_not @sales_entry.valid?
    @sales_entry.amount = -1
    assert_not @sales_entry.valid?
  end

  test "method should be direct or referral" do
    @sales_entry.method = 'invalid'
    assert_not @sales_entry.valid?
    @sales_entry.method = 'direct'
    assert @sales_entry.valid?
    @sales_entry.method = 'referral'
    assert @sales_entry.valid?
  end

  test "should calculate xp on create" do
    @sales_entry.save
    assert @sales_entry.xp_earned > 0
  end
end
