require "visualize_activities/version"

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
    issues = VisualizeActivities::Query::Issues.search(
        ENV['OWNER'],
        ENV['REPOSITORY'],
        ENV['TARGET'],
        target_time,
    )

    template = <<template
# Assigned issues

<% issues.each do |issue| %>

<%= issue.to_markdown %>

<% end %>
template

    puts ERB.new(template).result(binding)
  end
end

require 'visualize_activities/query/base'
require 'visualize_activities/base'
