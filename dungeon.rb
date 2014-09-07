
###############################
# Classes for Game
###############################


# Creating Dungeon Class
class Dungeon
attr_accessor :player

  def initialize(player_name)
    @player = Player.new(player_name, 20)
    puts "Your starting health is #{@player.health} points"
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
    puts find_room_in_dungeon(@player.location).full_description
  end

  def find_room_in_dungeon(reference)
    @rooms.detect {|room| room.reference == reference}
  end

  def find_room_in_direction(direction)
    find_room_in_dungeon(@player.location).connections[direction]
  end

  # Method wich subtracts damage from player health.
  def post_monster_health(monster_damage, current_health)
    current_health = current_health - monster_damage
    @player.health = current_health + 1
          # had to add one so players don't get mad about
          # turn taking away 1 health point AND meeting monster
  end

  # Method which adds health to player
  def add_health(health_plus, current_health)
    current_health = health_plus + current_health
    @player.health = current_health + 1
  end


  ######## GOOOO! Game driver method
  def go(direction)
    # we don't want to assign players location to nil, want to keep it the same.
    room = find_room_in_direction(direction)

    if room
      puts "You go " + direction.to_s
      @player.location = room
      show_current_description
      # When player enters certain rooms, certain events happen
      if room == :redroom
        # if you enter redroom, new instance of class Monster created, param is random damage
        @minotaur = Monster.new("minotaur", rand(5..12))
        puts "Your health before the monster is #{@player.health}"
        post_monster_health(@minotaur.does_damage, @player.health)
      elsif room == :toyroom
        @ball_string = Healthpack.new("ball of string", 5)
        puts "DEBUG" + @ball_string.inspect
        add_health(@ball_string.restores_health, @player.health)
      elsif room == :goldroom
        abort"YOU WON! You can take as much gold as you want! Congrats!"
      end
    else
      puts "That is a wall"
    end

  end

  # Stores values about player and room

  class Player
    attr_accessor :name, :location, :health

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

  # note, maybe add name attribute and then use it in here
  class Monster
    attr_accessor :damage, :name

    def initialize(name, damage)
      @damage = damage
      @name = name
    end

    # Text for damage message, returning damage as value
    def does_damage
      puts "You encounter the dreadful #{@name}!"
      puts "The #{@name} takes away #{@damage} health points."
      return @damage
    end
  end

  class Healthpack
    attr_accessor :healthiness, :pack_name

    def initialize(pack_name, healthiness)
      @pack_name = pack_name
      @healthiness = healthiness
    end

    def restores_health
      puts "You found a #{@pack_name}."
      puts "The #{@pack_name} restores #{@healthiness} points."
      return @healthiness
    end
  end

end


# Welcome
puts "Hello, you are trapped in a labyrinth, see if you can get out!"
print "What is your name? > "
new_player = gets.chomp


###############################
# Gameboard setup
###############################


# Creates the main dungeon object
my_dungeon = Dungeon.new(new_player)


# Add rooms to the dungeon
my_dungeon.add_room(:largecave, "Large Cave", "a large cavernous cave", {:west => :smallcave, :south => :blueroom, :east => :redroom} )

my_dungeon.add_room(:smallcave, "Small Cave", "a small, claustrophobic cave", {:east => :largecave, :north => :goldroom})

my_dungeon.add_room(:goldroom, "Gold Room", "a room filled with gold!", {:south => :smallcave})

my_dungeon.add_room(:blueroom, "Blue Room", "a room filled with weird blue light", {:north => :largecave, :east => :toyroom})

my_dungeon.add_room(:redroom, "Red Room", "a room filled with terrible red light", {:west => :largecave, :south => :toyroom})

my_dungeon.add_room(:toyroom, "Toy Room", "a room filled with random toys", {:north => :redroom, :west => :blueroom})
# Start dungeon by placing player into large cave
my_dungeon.start(:largecave)


###############################
# Gameplay
###############################


while my_dungeon.player.health > 0
  puts "Would you like to go north, south, east, or west?"
  print "> "
  which_way = gets.chomp.to_sym
  my_dungeon.go(which_way)
  if which_way == :exit || which_way == :quit
    abort"Bye bye"
  end
  my_dungeon.player.health -= 1
  puts "your health is now #{my_dungeon.player.health}"

end

puts "You died!"
