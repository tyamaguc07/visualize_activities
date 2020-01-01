require 'minitest/autorun'

module TimeLineItemTest
  class IssueCommentTest < MiniTest::Unit::TestCase
    include TimeLineItemTest

    def setup
      @timeline_item = VisualizeActivities::TimelineItem::IssueComment.new('test_username', 'test_content', Time.now)
    end

    def test_duck_methods
      assert_equal(true, @timeline_item.active?)
      assert_equal(true, @timeline_item.comment?)
      assert_equal(false, @timeline_item.pull_request?)
      assert_equal(false, @timeline_item.reference_issue?)
    end
  end
end