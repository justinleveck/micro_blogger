require 'jumpstart_auth'

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
        when 'dm' then dm(parts[1], parts[2..-1].join(" "))
        when 'q' then puts "Goodbye!"
        else
          puts "Sorry, I don't know how to #{command}"
      end      
    end    
  end  
end

blogger = MicroBlogger.new
blogger.run