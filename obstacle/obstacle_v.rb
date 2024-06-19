require_relative 'player'

class Obstacle_v < Sprite
    attr_accessor :status
    def initialize(x, y, image)
        @status = {
            damage_v: rand(1..100),
        }
        super(x, y, image)
    end
    def update(player)
        self.x += player.status[:speed]
    end
    
    def hit(obj_v)
        if obj_v.is_a?(Player)
            puts "Hit detected damage_v: #{self.status[:damage_v]}"
            obj_v.shot(self)
            self.vanish
        end
    end
end
