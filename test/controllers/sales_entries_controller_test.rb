require "test_helper"

class SalesEntriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @goal = goals(:one)
    @user = users(:one)
  end

  test "should create sales_entry" do
    assert_difference("SalesEntry.count") do
      post sales_entries_url, params: { sales_entry: { amount: 5000, method: "direct", goal_id: @goal.id } }
    end

    assert_redirected_to root_path
    follow_redirect!
    assert_match "Sale tracked successfully!", response.body
  end

  test "should not create invalid sales_entry" do
    assert_no_difference("SalesEntry.count") do
      post sales_entries_url, params: { sales_entry: { amount: 0, method: "direct", goal_id: @goal.id } }
    end

    assert_redirected_to root_path
    follow_redirect!
    assert_match "Failed to track sale", response.body
  end

  test "should void sales_entry" do
    @sale = sales_entries(:one)
    patch sales_entry_url(@sale), params: { sales_entry: { status: 'voided' } }
    
    @sale.reload
    assert @sale.voided?
    assert_redirected_to root_path
  end
end
