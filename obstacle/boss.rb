require_relative 'player'

class Boss < Sprite
  attr_accessor :damage_boss
  def initialize(x, y, image)
    super(x, y, image)
    @damage_boss = 300
  end
  
  def update(player) 
      self.x += player.status[:speed]
  end

  def reset_position(x, y)
    self.x = x
    self.y = y
  end

  def hit(other)
    if other.is_a?(Player)
        puts "Hit detected boss"
        other.shot(self)
        self.vanish
    end
  end

end