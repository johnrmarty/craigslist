namespace :scraper do
  desc "Get Craigslist posts from 3Tap"
  task scrape: :environment do
  	require 'open-uri'
  	require 'json'

  	# Set API token and URL
    auth_token = "4c77c1fdabad9873ddec7823589e8d23"
    polling_url = "http://polling.3taps.com/poll"

    # Specify request parameters
    params = {
      auth_token: auth_token,
      anchor: 1897088399,
      source: "CRAIG",
      category_group: "RRRR",
      category: "RHFR",
      'location.city' => "USA-NYM-BRL",
      retvals: "location,external_url,heading,body,timestamp,price,images,annotations"
    }

    uri = URI.parse(polling_url)
    uri.query = URI.encode_www_form(params)

    # Submit request
    result = JSON.parse(open(uri).read)

    # Display results to screen
    # puts result["postings"].second["location"]["locality"]
    # puts JSON.pretty_generate result["postings"].first["heading"]
  
    result["postings"].each do |posting|

      @post = Post.new
      @post.heading = posting["heading"]
      @post.body = posting["body"]
      @post.price = posting["price"]
      @post.neighborhood = posting["location"]["locality"]
      @post.external_url = posting["external_url"]
      @post.timestamp = posting["timestamp"]
      @post.save

    end 


  	end

  	desc "TODO"
  	task destroy_all_posts: :environment do
  	end

end
