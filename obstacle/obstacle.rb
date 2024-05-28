class Obstacle < Sprite
    attr_accessor :status
    def initialize(x, y, image)
        @status = {
            damage: rand(1..70),
            slow: 2
        }
        super(x, y, image)
    end
    def update
        self.x += 1
    end
    
    def hit(obj)
        if obj.is_a?(Player)
            puts "Hit detected: #{self.status[:damage]}"
            obj.shot(self)
            self.vanish
        end
    end
end
