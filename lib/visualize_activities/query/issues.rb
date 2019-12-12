module VisualizeActivities::Query
  class Issues
    def self.search(setting)
      return Issues.new(setting).search
    end

    def initialize(setting)
      @setting = setting
    end

    attr_reader :setting

    def search
      assigned, contributed = [], []
      has_next_page, after = true, nil

      while has_next_page
        result = VisualizeActivities::Client.query(Query, variables: {
            owner: setting.owner,
            repository: setting.repository,
            since: setting.target_time.iso8601,
            after: after,
        })

        data = result.data.repository.issues

        issues = issues_mapper(data.nodes)

        assigned += issues[:assigned]
        contributed += issues[:contributed]

        has_next_page, after = data.page_info.has_next_page, data.page_info.end_cursor
      end

      return VisualizeActivities::IssueSet.new(assigned), VisualizeActivities::IssueSet.new(contributed)
    end

    private

    def issues_mapper(issues)
      issues.each_with_object({assigned: [], contributed: []}) do |issue, results|
        timeline_item_set = generate_timeline_item_set(issue.timeline_items.edges.map(&:node))

        if issue.assignees.nodes.map(&:login).any?(setting.target) && timeline_item_set.has_active_item?
          results[:assigned] << VisualizeActivities::Issue.new(
              issue.title,
              issue.body_html,
              issue.url,
              issue.created_at,
              timeline_item_set,
              )
        else
          next if timeline_item_set.not_exists?
          results[:contributed] << VisualizeActivities::Issue.new(
            issue.title,
            issue.body_html,
            issue.url,
            issue.created_at,
            timeline_item_set,
            )
        end
      end
    end

    def generate_timeline_item_set(timeline_items)
      results = timeline_items.each_with_object([]) do |timeline_item, results|
        result = case timeline_item.__typename
                 when "CrossReferencedEvent"
                   VisualizeActivities::TimelineItem::CrossReferencedEvent.new(timeline_item.actor.login, timeline_item.url, timeline_item.created_at)
                 when "IssueComment"
                   VisualizeActivities::TimelineItem::IssueComment.new(timeline_item.author.login, timeline_item.body_html, timeline_item.created_at)
                 else
                   next
                 end
        results << result if setting.target == result.username && setting.target_time.within?(result.created_at)
      end
      VisualizeActivities::TimelineItemSet.new(results)
    end


    Query = VisualizeActivities::Client.parse <<-GraphQL
query($owner: String!, $repository: String!, $since: DateTime!, $after: String) {
  repository(owner: $owner, name: $repository) {
    issues(filterBy: {since: $since} first: 100, after: $after) {
      pageInfo {
        endCursor
        hasNextPage
      }
      nodes {
        title
        assignees(first: 5) {
          nodes {
            login
          }
        }
        bodyHTML
        url
        createdAt
        timelineItems(
          itemTypes: [CROSS_REFERENCED_EVENT, ISSUE_COMMENT],
          since: $since,
          first: 100) {
          edges {
            node {
              __typename
              ... on CrossReferencedEvent {
                actor {login}
                url
                createdAt
              }
              ... on IssueComment{
                author {login}
                bodyHTML
                createdAt
              }
            }
          }
        }
      }
    }
  }
}
    GraphQL
  end
end
