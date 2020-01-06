require 'minitest/autorun'

class TimelineItemSetTest < MiniTest::Unit::TestCase
  def setup
  end

  def test_exists?
    timeline_item_set = VisualizeActivities::TimelineItemSet.new(['dummy'])
    assert_equal(true, timeline_item_set.exists?)
  end

  def test_not_exists?
    timeline_item_set = VisualizeActivities::TimelineItemSet.new([])
    assert_equal(true, timeline_item_set.not_exists?)
  end

  def test_comments
    issue_comment_01 = VisualizeActivities::TimelineItem::IssueComment.new('test_username', 'test_content_01', Time.now)
    issue_comment_02 = VisualizeActivities::TimelineItem::IssueComment.new('test_username', 'test_content_02', Time.now)
    pull_request_01 = VisualizeActivities::TimelineItem::CrossReferencedEvent.new('test_username', 'https://github.com/#ref-pullrequest-', Time.now)

    timeline_item_set = VisualizeActivities::TimelineItemSet.new([issue_comment_01, issue_comment_02, pull_request_01])

    assert_equal([issue_comment_01, issue_comment_02], timeline_item_set.comments)
  end
end