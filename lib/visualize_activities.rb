require "visualize_activities/version"

require 'active_support'
require 'active_support/time'

require "graphql/client"
require "graphql/client/http"

require 'erb'

module VisualizeActivities
  HTTP = GraphQL::Client::HTTP.new('https://api.github.com/graphql') do
    def headers(context)
      {
          "Authorization" => "Bearer #{ENV['GITHUB_ACCESS_TOKEN_FOR_VISUALIZE_ACTIVITIES']}"
      }
    end
  end

  Schema = GraphQL::Client.load_schema(HTTP)
  Client = GraphQL::Client.new(schema: Schema, execute: HTTP)

  class Error < StandardError; end

  def self.execute(target_date)
    target_time = TargetTime.new(target_date)
    target = ENV['TARGET']

    assigned_issue_set, contributed_issue_set = VisualizeActivities::Query::Issues.search(
        ENV['OWNER'],
        ENV['REPOSITORY'],
        ENV['TARGET'],
        target_time,
    )

    template = <<template
# <%= ENV['REPOSITORY'] %>

## Assigned issues

<% assigned_issue_set.each do |issue| %>

<%= issue.to_markdown %>

<% end %>

## Contributed issues

<% contributed_issue_set.each do |issue| %>

<%= issue.to_markdown %>

### Comments

<% issue.comments.each do |comment| %>

<%= comment.to_markdown %>

<% end %>
<% end %>

template

    puts ERB.new(template).result(binding)
  end
end

require 'visualize_activities/target_time'

require 'visualize_activities/query'

require 'visualize_activities/issue'
require 'visualize_activities/issue_set'
require 'visualize_activities/timeline_item'
require 'visualize_activities/timeline_item_set'
