require_relative 'player'

class Obstaclespeed < Sprite
    attr_accessor :status
    def initialize(x, y, image)
        @status = {
            slow: rand(1..8) #変更点
        }
        @image_down = Image.load('image/kaze.png')
        @image_up = Image.load('image/kasoku.png')
        # 初期画像の設定
        case @status[:slow]
        when 1..4
        super(x, y, @image_down)
        when 5..8
        super(x, y, @image_up)
        else
        raise ArgumentError, "Unexpected slow value: #{@status[:slow]}"
        end
    end
    def update(player)
        self.x += player.status[:speed]
    end
    
    def hit(obj)
        if obj.is_a?(Player)
            puts "Hit detected slow: #{self.status[:slow]}"
            obj.shot(self)
            self.vanish
        end
    end
end