class Vertical_h < Sprite
    @@count = 0
    @@initial_vertical_h_position = nil
  
    def initialize(x, y, image)
      # プレイヤーの位置とサイズを設定
      image = Image.new(10, 10, [255, 255, 255])
      super(x, y, image)
  
      if @@initial_vertical_h_position.nil?
        @@initial_vertical_h_position = [x, y]
      end
  
      @@count += 1
      @direction = 1 # 移動方向を保持する変数を追加（1：下方向、-1：上方向）
    end
  
    def self.initial_vertical_h_position
        @@initial_vertical_h_position
    end

    def update
        self.y += Input.y * @direction
        if self.y < 100 || self.y > Window.height
            self.vanish
        end
    end
end