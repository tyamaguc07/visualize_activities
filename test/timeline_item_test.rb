require 'minitest/autorun'

module TimeLineItemTest
  def test_implemented_interface
    assert_respond_to(@timeline_item, :active?)
    assert_respond_to(@timeline_item, :comment?)
    assert_respond_to(@timeline_item, :pull_request?)
    assert_respond_to(@timeline_item, :reference_issue?)
    assert_respond_to(@timeline_item, :to_markdown)
  end
end