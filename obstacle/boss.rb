require_relative 'player'

class Boss < Sprite
  attr_accessor :damage
  def initialize(x, y, image)
    @damage = 300
    super(x, y, image)
  end
  
    def update(player) 
        self.x += 3
    end
  end