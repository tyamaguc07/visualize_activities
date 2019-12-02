require "visualize_activities/version"

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
  # Your code goes here...
end

require 'visualize_activities/issues'
