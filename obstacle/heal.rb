class Heal < Sprite
    attr_accessor :status
    def initialize(x, y, image)
        @status = {
            heal: rand(1..70),
            slow: 2
        }
        super(x, y, image)
    end
    #ここから変更点
    def update(player) 
        self.x += player.status[:speed]
    end
    #ここまで変更点
    
    def hit(obj)
        if obj.is_a?(Player)
            puts "Hit Healed: #{self.status[:heal]}"
            obj.shot(self)
            self.vanish
        end
    end
end
