require "visualize_activities/version"

require 'active_support'
require 'active_support/time'

require "graphql/client"
require "graphql/client/http"

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
    setting = VisualizeActivities::Setting.new(
        ENV['OWNER'],
        ENV['REPOSITORY'],
        ENV['TARGET'],
        TargetTime.new(target_date),
        )

    results = VisualizeActivities::Visualizer::Issue.execute(setting)

    puts results
  end
end

require 'visualize_activities/setting'
require 'visualize_activities/target_time'

require 'visualize_activities/visualizer/issue'

require 'visualize_activities/query'

require 'visualize_activities/issue'
require 'visualize_activities/issue_set'
require 'visualize_activities/timeline_item'
require 'visualize_activities/timeline_item_set'
