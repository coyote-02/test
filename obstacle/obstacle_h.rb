require_relative 'player'

class Obstacle_h < Sprite
    attr_accessor :status
    def initialize(x, y, image)
        @status = {
            damage_h: rand(1..100),
        }
        super(x, y, image)
    end
    def update(player)
        self.x += player.status[:speed]
    end
    
    def hit(obj_h)
        if obj_h.is_a?(Player)
            puts "Hit detected damage_h: #{self.status[:damage_h]}"
            obj_h.shot(self)
            self.vanish
        end
    end
end
