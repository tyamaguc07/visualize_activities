module VisualizeActivities::Query
  class Issues
   def self.search(owner, repository, target, target_time)
     issues = []
     has_next_page, after = true, nil

     while has_next_page
       result = VisualizeActivities::Client.query(Query, variables: {
           owner: owner,
           repository: repository,
           since: target_time.iso8601,
           after: after,
       })

       data = result.data.repository.issues

       issues += issues_mapper(data.nodes)
       has_next_page, after = data.page_info.has_next_page, data.page_info.end_cursor
     end

      VisualizeActivities::IssueSet.new(issues)
    end

    def self.issues_mapper(issues)
      issues.map do |issue|
        timeline_items = timeline_items_mapper(issue.timeline_items.edges.map(&:node))

        VisualizeActivities::Issue.new(
            issue.title,
            issue.body_html,
            issue.assignees.nodes.map(&:login),
            issue.url,
            issue.created_at,
            VisualizeActivities::TimelineItemSet.new(timeline_items),
            )
      end
    end

    def self.timeline_items_mapper(timeline_items)
      timeline_items.each_with_object([]) do |timeline_item, result|
        result << case timeline_item.__typename
                  when "CrossReferencedEvent"
                    VisualizeActivities::TimelineItem::CrossReferencedEvent.new(timeline_item.actor.login, timeline_item.url, timeline_item.created_at)
                  when "IssueComment"
                    VisualizeActivities::TimelineItem::IssueComment.new(timeline_item.author.login, timeline_item.body_html, timeline_item.created_at)
                  else
                    next
                  end
      end
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
          itemTypes: [ASSIGNED_EVENT, CROSS_REFERENCED_EVENT],
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
