class Vertical_v < Sprite
    @@count = 0
    @@initial_vertical_v_position = nil
  
    def initialize(x, y, image)
      # プレイヤーの位置とサイズを設定
      image = Image.new(10, 10, [255, 255, 255])
      super(x, y, image)
  
      if @@initial_vertical_v_position.nil?
        @@initial_vertical_v_position = [x, y]
      end
  
      @@count += 1
      @direction = 1 # 移動方向を保持する変数を追加（1：下方向、-1：上方向）
    end
  
    def self.initial_vertical_v_position
        @@initial_vertical_v_position
    end

    def update
        self.y += Input.y * @direction * 2
        if self.y < 100 || self.y > Window.height
          unless @vanished
            $num_vertical_vs -= 1
            # 0未満にならないようにする
            $num_vertical_vs = [$num_vertical_vs, 0].max
            puts "Num vertical_vs: #{$num_vertical_vs}"
            self.vanish
            @vanished = true
          end
        end
    end
end