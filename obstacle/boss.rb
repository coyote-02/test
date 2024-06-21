require_relative 'player'

class Boss < Sprite
    attr_accessor :status
    def initialize(x, y, image)
        @status = {
            damage_boss: 300,
        }
        super(x, y, image)
    end
    def update(player)
        self.x += player.status[:speed]
    end
    
    def hit(obj_boss)
        if obj_boss.is_a?(Player)
            puts "Hit detected boss: #{self.status[:damage_boss]}"
            obj_boss.shot(self)
    
            self.vanish
        end
    end

    def reset_position(x,y)
      @position = { x: -300, y: 100 } # 位置をリセット
    end

end
