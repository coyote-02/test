#"class Bullet < Sprite
    #def initialize(x, y)
      #image = Image.load("image/明度アイコン.png")
      #super(x, y, image)
    #end
  
    #def update
      #self.x += 10  # 弾の移動
      #self.vanish if self.x > Window.width  # ウィンドウ外に出たら消滅
    #end
  #end

class Bullet < Sprite
  attr_accessor :status
  def initialize(x,y,image, speed, power)
    @status ={
      speed: 1,
      power: player.status[:health]
    }
    super(x,y,image)
  end

  def update
    self.x -= @status[:speed]
    if self.x < 0
      self.vanish
    end
  end
end