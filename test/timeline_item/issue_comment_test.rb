require 'minitest/autorun'

module TimeLineItemTest
  class IssueCommentTest < MiniTest::Unit::TestCase
    include TimeLineItemTest

    def setup
      @timeline_item = VisualizeActivities::TimelineItem::IssueComment.new('test_username', 'test_content', Time.now)
    end

    def teardown
      # Do nothing
    end
  end
end