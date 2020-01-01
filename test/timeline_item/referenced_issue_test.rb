require 'minitest/autorun'

module TimeLineItemTest
  class ReferencedIssue < MiniTest::Unit::TestCase
    include TimeLineItemTest

    def setup
      @timeline_item = VisualizeActivities::TimelineItem::CrossReferencedEvent.new('test_username', 'https://github.com/example#ref-issue-', Time.now)
    end

    def test_duck_methods
      assert_equal(false, @timeline_item.active?)
      assert_equal(false, @timeline_item.comment?)
      assert_equal(false, @timeline_item.pull_request?)
      assert_equal(true, @timeline_item.reference_issue?)
    end
  end
end
