require_relative 'player'

class Obstaclespeed < Sprite
    attr_accessor :status
    def initialize(x, y, image)
        @status = {
            slow: 2
        }
        super(x, y, image)
    end
    def update(player)
        self.x += player.status[:speed]
    end
    
    def hit(obj)
        if obj.is_a?(Player)
            puts "Hit detected slow: #{self.status[:slow]}"
            obj.shot(self)
            self.vanish
        end
    end
end