class Obstacle_v < Sprite
    attr_accessor :status
    def initialize(x, y, image)
        @status = {
            damage_v: rand(1..20),
        }
        super(x, y, image)
    end
    def update(player)
        self.x += player.status[:speed]
    end
    
    def hit(obj_v)
        if obj_v.is_a?(Player)
            puts "Hit detected damage_v: #{self.status[:damage_v]}"
            obj_v.shot(self)
            self.vanish
        end
    end

    # 画面外に出たかどうかをチェックするメソッド
    def is_outside_screen(screen_width, screen_height)
        @x < 0 || @x > screen_width || @y < 0 || @y > screen_height
    end

end
