class Obstacle_v < Sprite
    attr_accessor :status
    def initialize(x, y, image)
        @status = {
            damage_v: rand(1..70),
        }
        super(x, y, image)
    end
    
    def update(player)
        self.x += player.status[:speed]
    end
    
    def recreate_vertical_vs
        $vertical_vs = create_vertical_vs($num_vertical_vs, $vertical_v_x, $vertical_v_y, $vertical_v_img)
    end

    def hit(obj_v)
        if obj_v.is_a?(Vertical_v)
            obj_v.vanish
            $num_vertical_vs -= 1
            $num_vertical_vs = [$num_vertical_vs, 0].max
            puts "Num vertical_vs: #{$num_vertical_vs}"
            recreate_vertical_vs if $num_vertical_vs > 0
        end
    end

    # 画面外に出たかどうかをチェックするメソッド
    def is_outside_screen(screen_width, screen_height)
        @x < 0 || @x > screen_width || @y < 0 || @y > screen_height
    end

end
