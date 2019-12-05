module VisualizeActivities
  Issue = Struct.new(:author, :title, :body, :url, :created_at) do

    def to_markdown
      <<-"MARKDOWN"
### [#{title}](#{url})

<pre>#{body}</pre>
      MARKDOWN
    end
  end
end
