
###############################
# Classes for Game
###############################

# Creating Dungeon Class

class Dungeon
attr_accessor :player

  def initialize(player_name)
    @player = Player.new(player_name, 20)
    puts @player.class
    puts @player.health # it appears to return a value here, not nil.
    @rooms = []

  end

  # method adds rooms to dungeon
  def add_room(reference, name, description, connections)
    @rooms << Room.new(reference, name, description, connections)
  end

  # method places user at start of game
  def start(location)
    @player.location = location
    show_current_description
  end

  def show_current_description
    # puts "DEBUG show_current player location " + @player.location.inspect
    puts find_room_in_dungeon(@player.location).full_description
  end

  def find_room_in_dungeon(reference)
    @rooms.detect {|room| room.reference == reference}
  end

  def find_room_in_direction(direction)
    # puts "DEBUG find_room starting location " + @player.location.inspect
    find_room_in_dungeon(@player.location).connections[direction]
  end

  ######## GOOOO! Game driver method?
  def go(direction)
    # we don't want to assign players location to nil, want to keep it the same.
    room = find_room_in_direction(direction)
    # puts "DEBUG " + room.inspect

    if room
      puts "You go " + direction.to_s
      @player.location = room
      # puts "DEBUG #{room.class}"
      show_current_description
      if room == :goldroom
        abort"YOU WON! You can take as much gold as you want! Congrats!"
      end
    else
      puts "That is a wall"
    end

  end

  #stores values about player and room

  class Player
    attr_accessor :name, :location, :health
        # note, health is not working yet...
    def initialize(player_name, health)
      @name = player_name
      @health = health
    end
  end

  class Room
    attr_accessor :reference, :name, :description, :connections

    def initialize(reference, name, description, connections)
      @reference = reference
      @name = name
      @description = description
      @connections = connections
    end

    def full_description
      @name + "\n\nYou are in " + @description
    end
  end

end


# Welcome
puts "Hello, you are trapped in a dungeon, see if you can get out!"
print "What is your name? > "
new_player = gets.chomp


###############################
# Object my_dungeon creation
###############################


# Creates the main dungeon object
my_dungeon = Dungeon.new(new_player)


# Add rooms to the dungeon
my_dungeon.add_room(:largecave, "Large Cave", "a large cavernous cave", {:west => :smallcave, :south => :blueroom, :east => :redroom} )

my_dungeon.add_room(:smallcave, "Small Cave", "a small, claustrophobic cave", {:east => :largecave, :north => :goldroom})

my_dungeon.add_room(:goldroom, "Gold Room", "a room filled with gold!", {:south => :smallcave})

my_dungeon.add_room(:blueroom, "Blue Room", "a room filled with weird blue light", {:north => :largecave})

my_dungeon.add_room(:redroom, "Red Room", "a room filled with terrible red light", {:west => :largecave})

# Start dungeon by placing player into large cave
my_dungeon.start(:largecave)


###############################
# Gameplay
###############################


# still not working
puts my_dungeon.player.health
while my_dungeon.player.health > 0
  puts "Would you like to go north, south, east, or west?"
  print "> "
  which_way = gets.chomp.to_sym
  my_dungeon.go(which_way)
  my_dungeon.player.health -= 1
  puts "your health is now #{my_dungeon.player.health}"
  if which_way == :exit || which_way == :quit
    abort"Bye bye"
  end

end
