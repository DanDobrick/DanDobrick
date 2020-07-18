require 'feedparser'

RSS_URL = "https://dandobrick.com/blog/feed.xml"

def posts_as_markdown(posts_to_list)
  posts_mardown = posts_to_list.map do |post|
    formatted_time = post.published.strftime("%m-%d-%Y")
    "- [#{post.title}](#{post.url}) - #{formatted_time}"
  end
  posts_mardown.join("\n")
end

# Get posts from feed, grab the latest 5 and turn them into a markdown list
feed = open(RSS_URL).read
parsed_feed = FeedParser::Parser.parse(feed)
sorted_posts = parsed_feed.items.sort_by(&:published).reverse
post_list = posts_as_markdown(sorted_posts[0..4])

# Open readme, find blog list, replace it with new blog list
readme_text = File.read('./README.md')
new_content = "<!-- blog starts -->\n#{post_list}\n<!-- blog ends -->"
blog_regex = /<!-- blog starts -->[\s\S]*<!-- blog ends -->/
new_text = readme_text.gsub(blog_regex, new_content)

# Write new blog list to readme.
File.open('./README.md', 'w') { |file| file.puts new_text}
