class Obstacle < Sprite
    attr_accessor :status
    def initialize(x, y, image)
        @status = {
            damage: 40,
            slow: 2
        }
        super(x, y, image)
    end
    def update
        self.y += 1
    end
    
    def hit
        self.vanish
    end
end