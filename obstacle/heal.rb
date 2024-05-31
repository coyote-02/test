class Heal < Sprite
    attr_accessor :status
    def initialize(x, y, image)
        @status = {
            heal: rand(1..70),
            slow: 2
        }
        super(x, y, image)
    end
    def update
        self.x += 1
    end
    
    def hit(obj)
        if obj.is_a?(Player)
            puts "Hit Healed: #{self.status[:heal]}"
            obj.shot(self)
            self.vanish
        end
    end
end