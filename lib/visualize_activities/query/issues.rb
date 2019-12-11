module VisualizeActivities::Query
  class Issues
    def self.search(owner, repository, target, target_time)
      return Issues.new(owner, repository, target, target_time).search
    end

    def initialize(owner, repository, target, target_time)
      @owner = owner
      @repository = repository
      @target = target
      @target_time = target_time
    end

    attr_reader :owner, :repository, :target, :target_time

    def search
      assigned, contributed = [], []
      has_next_page, after = true, nil

      while has_next_page
        result = VisualizeActivities::Client.query(Query, variables: {
            owner: owner,
            repository: repository,
            since: target_time.iso8601,
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
        timeline_items = timeline_items_mapper(issue.timeline_items.edges.map(&:node))

        if issue.assignees.nodes.map(&:login).any?(target)
          results[:assigned] << VisualizeActivities::Issue.new(
              issue.title,
              issue.body_html,
              issue.url,
              issue.created_at,
              VisualizeActivities::TimelineItemSet.new(timeline_items),
              )
        else
          next if timeline_items.empty?
          results[:contributed] << VisualizeActivities::Issue.new(
            issue.title,
            issue.body_html,
            issue.url,
            issue.created_at,
            VisualizeActivities::TimelineItemSet.new(timeline_items),
            )
        end
      end
    end

    def timeline_items_mapper(timeline_items)
      timeline_items.each_with_object([]) do |timeline_item, results|
        result = case timeline_item.__typename
                 when "CrossReferencedEvent"
                   VisualizeActivities::TimelineItem::CrossReferencedEvent.new(timeline_item.actor.login, timeline_item.url, timeline_item.created_at)
                 when "IssueComment"
                   VisualizeActivities::TimelineItem::IssueComment.new(timeline_item.author.login, timeline_item.body_html, timeline_item.created_at)
                 else
                   next
                 end
        results << result if target == result.username && target_time.within?(result.created_at)
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
