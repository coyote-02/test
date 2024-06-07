require_relative 'player'

class Obstaclespeed < Sprite
    attr_accessor :status
    def initialize(x, y, image)
        @status = {
            slow: rand(1..8) #変更点
        }
        super(x, y, image)
    end
    def update(player)
        self.x += player.status[:speed]
        #ここから変更点
        if player.status[:speed] > 10
            player.status[:speed] = 10
        end
        if player.status[:speed] < 0.1
            player.status[:speed] = 0.1
        end
        #ここまで変更点
    end
    
    def hit(obj)
        if obj.is_a?(Player)
            puts "Hit detected slow: #{self.status[:slow]}"
            obj.shot(self)
            self.vanish
        end
    end
end