module VisualizeActivities::Query
  class PullRequests
    def self.search(setting)
      return PullRequests.new(setting).search
    end

    def initialize(setting)
      @setting = setting
    end

    attr_reader :setting

    def search
      created, contributed = [], []
      after = nil

      100.times do
        result = VisualizeActivities::Client.query(Query, variables: {
            owner: setting.owner,
            repository: setting.repository,
            after: after,
        })

        data = result.data.repository.pull_requests

        pull_requests = pull_requests_mapper(data.nodes)

        created += pull_requests[:created]
        contributed += pull_requests[:contributed]

        after = data.page_info.end_cursor

        break if setting.target_time.start_time > data.nodes.last.updated_at
      end

      return created, contributed
    end

    private

    def pull_requests_mapper(pull_requests)
      pull_requests.each_with_object({created: [], contributed: []}) do |pull_request, results|
        review_set = generate_review_set(pull_request.reviews.nodes)
        comment_set = generate_comment_set(pull_request.comments.nodes)

        next if review_set.not_exists? && comment_set.not_exists? && (pull_request.merged && setting.target_time.without?(pull_request.merged_at))

        if pull_request.author.login == setting.target
          results[:created] << VisualizeActivities::PullRequest.new(
            pull_request.title,
            pull_request.body_html,
            pull_request.url,
            review_set,
            comment_set,
            pull_request.updated_at,
          )
        else
          results[:contributed] << VisualizeActivities::PullRequest.new(
            pull_request.title,
            pull_request.body_html,
            pull_request.url,
            review_set,
            comment_set,
            pull_request.updated_at,
          )
        end
      end
    end

    def generate_review_set(reviews)
      results = reviews.each_with_object([]) do |review, results|
        comment_set = generate_comment_set(review.comments.nodes)
        next if comment_set.not_exists?

        results << VisualizeActivities::PullRequest::Review.new(comment_set)
      end

      VisualizeActivities::PullRequest::ReviewSet.new(results)
    end

    def generate_comment_set(comments)
      results = comments.each_with_object([]) do |comment, results|
        next if setting.target != comment.author.login || setting.target_time.without?(comment.created_at)
        results << VisualizeActivities::PullRequest::Comment.new(
          comment.author.login,
          comment.url,
          comment.body_html,
          comment.respond_to?(:diff_hunk) && comment.diff_hunk,
          comment.created_at,
        )
      end
      VisualizeActivities::PullRequest::CommentSet.new(results)
    end

    Query = VisualizeActivities::Client.parse <<-GraphQL
query($owner: String!, $repository: String!, $after: String) {
  repository(owner: $owner, name: $repository) {
    pullRequests(after: $after, orderBy: {field: UPDATED_AT, direction: DESC}, first: 100) {
      nodes {
        author {
          login
        }
        title
        url
        bodyHTML
        updatedAt
        closed
        closedAt
        merged
        mergedAt
        comments(first: 20) {
          nodes {
            author {
              login
            }
            bodyHTML
            url
            createdAt
          }
        }
        reviews(first: 100) {
          nodes {
            author {
              login
            }
            createdAt
            comments(first: 10) {
              nodes {
                author {
                  login
                }
                bodyHTML
                diffHunk
                url
                createdAt
              }
            }
          }
        }
      }
      pageInfo {
        endCursor
      }
    }
  }
}
    GraphQL
  end
end
