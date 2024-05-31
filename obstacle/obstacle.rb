require_relative 'player'

class Obstacle < Sprite
    attr_accessor :status
    def initialize(x, y, image)
        @status = {
            damage: rand(1..70),
            #slow: 2 #変更点(削除)
        }
        super(x, y, image)
    end
    def update(player) #変更点
        self.x += player.status[:speed] #変更点
    end
    
    def hit(obj)
        if obj.is_a?(Player)
            puts "Hit detected damage: #{self.status[:damage]}" #変更点
            obj.shot(self)
            self.vanish
        end
    end
end
