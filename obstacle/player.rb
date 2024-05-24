class Player < Sprite
    attr_accessor :status
    def initialize(x, y, image)
        @status = {
            health: 100,
            speed: 10
        }
        super(x, y, image)
    end
    def update
        self.x += Input.x
        self.y += Input.y
    end
end
