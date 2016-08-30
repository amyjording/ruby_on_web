require 'jumpstart_auth'

class MicroBlogger
  attr_reader :client

  def initialize
    puts "Initializing MicroBlogger"
    @client = JumpstartAuth.twitter
  end

  def shorten(original_url)
    bitly = Bitly.new('')
    puts "Shortening this URL: #{original_url}"
    bitly.shorten(original_url).short_url
  end

  def tweet(message)
    if message.length <= 140
      @client.update(message)
    else
      puts "Your tweet message is too long and will not post."
    end
  end

  def dm(target, message)
    screen_names = @client.followers.collect { |follower| @client.user(follower).screen_name }

    if target.include? screen_names
    puts "Trying to send #{target} this direct message:"
    puts message
    message = "d @#{target} #{message}"
    tweet(message)
    else
    puts "You can only send a message to people who follow you."
    end
  end

  def followers_list
    screen_names = []
    screan_names << @client.followers.each { |follower| screen_names << @client.user(follower).screen_name }
    screen_names
  end

  def spam_my_followers(message)
    followers = followers.list
    followers.each { |follower| dm(follower, message) }
  end

  def everyones_last_tweet
    friends = @client.friends
    friends.each do |friend|
      tstamp = friend.status.created_at
      puts "#{friend.screen_name} said the this on #{tstamp.strftime(%A, %b %d)}... #{friend.status.text}"
      puts " "
    end
  end

  def run
    puts "Welcome to the JSL Twitter Client!"
    command = ""

    while command != "q"
      printf "Enter command: "
      input = gets.chomp
      parts = input.split(" ")
      command = parts[0]

      case command
        when 'q' then puts "Goodbye!"
        when 't' then tweet(parts[1..-1].join(" "))
        when 'dm' then dm(parts[1], parts[2..-1].join(" "))
        when 'spam' then spam_my_followers(parts[1..-1]).join(" "))
        when 'elt' then self.everyones_last_tweet
        when 's' then shorten(parts[1..-1].join)
        when 'turl' then tweet(parts[1..-2]).join(' ') + ' ' + shorten(parts[-1]))
        else
          puts "Sorry, I don't know how to #{command}"
      end
    end
  end
end

blogger = MicroBlogger.new
blogger.run
