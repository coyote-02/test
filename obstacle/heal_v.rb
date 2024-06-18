class Heal_v < Sprite
    attr_accessor :status
    def initialize(x, y, image)
        @status = {
            heal_v: rand(1..100),
            slow: 2
        }
        super(x, y, image)
    end
    #ここから変更点
    def update(player) 
        self.x += player.status[:speed]
    end
    #ここまで変更点
    
    def hit(obj_v)
        if obj_v.is_a?(Player)
            puts "Hit Healed: #{self.status[:heal_v]}"
            obj_v.shot(self)
            self.vanish
        end
    end
end

