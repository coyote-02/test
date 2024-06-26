class Heal_h < Sprite
    attr_accessor :status
    def initialize(x, y, image)
        @status = {
            heal_h: rand(1..100),
            slow: 2
        }
        super(x, y, image)
    end
    
    def update(player) 
        self.x += player.status[:speed]
    end
    
    def hit(obj_h)
        if obj_h.is_a?(Player)
            puts "Hit Healed: #{self.status[:heal_h]}"
            obj_h.shot(self)
            self.vanish
        end
    end
end
