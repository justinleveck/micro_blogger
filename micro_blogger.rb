require 'jumpstart_auth'
require 'bitly'
Bitly.use_api_version_3

class MicroBlogger
  attr_reader :client

  def initialize
    puts "Initializing..."
    @client = JumpstartAuth.twitter
  end

  def tweet(message)
   @client.update(message)
  end  

  def followers_list
    screen_names = @client.followers.collect{|follower| follower.screen_name}
  end

  def spam_my_followers(message)
    followers_list.each do |f|
      dm(f,message)
    end
  end

  def dm(target, message)
    if followers_list.include? target    
    puts "Trying to send #{target} this direct message:"    
    puts message
    tweet("d #{target} #{message}")
    else
      puts "Sorry, direct message not sent. Target is not a follower."
    end
  end

  def everyones_last_tweet
    friends = @client.friends
    friends.sort_by!{|f| f.screen_name.downcase }.each do |friend|
      puts "#{friend.screen_name} said..."
      puts friend.status.source
    end
    puts "\n"
  end

  def shorten(original_url)
    puts "Shortening this URL: #{original_url}"
    bitly = Bitly.new('hungryacademy', 'R_430e9f62250186d2612cca76eee2dbc6')
    bitly.shorten(original_url).short_url
  end  

  def run
    puts "Welcome to the JSL Twitter Client!"
    command = ""
    while command != "q"
      printf "enter command: "
      input = gets.chomp
      parts = input.split(" ")
      command = parts[0]
      case command
        when 't' then tweet(parts[1..-1].join(" "))
        when 'spam' then spam_my_followers(parts[1..-1].join(" "))
        when 'elt' then everyones_last_tweet
        when 'dm' then dm(parts[1], parts[2..-1].join(" "))
        when 's' then shorten(parts[1..-1].join(" ")) 
        when 'turl' then tweet(parts[1..-2].join(" ") + " " + shorten(parts[-1]))                 
        when 'q' then puts "Goodbye!"
        else
          puts "Sorry, I don't know how to #{command}"
      end      
    end    
  end  
end

blogger = MicroBlogger.new
blogger.run