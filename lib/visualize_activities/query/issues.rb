module VisualizeActivities::Query
  class Issues
    def self.search(owner, repository, target, target_time)
      result = VisualizeActivities::Client.query(Query, variables: {
        owner: owner,
        repository: repository,
        since: target_time.iso8601,
      })

      result.data.repository.issues.nodes.map do |issue|
        VisualizeActivities::Issue.new(issue.title, issue.body_html, issue.url, issue.created_at)
      end
    end

    Query = VisualizeActivities::Client.parse <<-GraphQL
query($owner: String!, $repository: String!, $since: DateTime!) {
  repository(owner: $owner, name: $repository) {
    issues(filterBy: {since: $since} first: 100) {
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
