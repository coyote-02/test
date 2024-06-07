require_relative 'player'

class Boss < Sprite
    def initialize(x,y,image)
      super
    end
  
    def update(player) 
        self.x += player.status[:speed]
    end
  end