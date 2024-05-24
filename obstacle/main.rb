require 'dxruby'
require_relative "obstacle"
require_relative "player"

# ウィンドウのサイズを設定
Window.width = 1200
Window.height = 700

obstacle_img = Image.load("image/enemy.png")
obstacle_img = Image.load("image/player.png")

x1 = 100
y1 = 100
count = 0
obstacle = Obstacle.new(100, y1 + count, obstacle_img)

obstacle_font = Font.new(32)
y2 = 100

player_img = Image.load("image/player.png")
player = Player.new(100, 300, player_img)
player_font = Font.new(32)

#背景
kumo = Image.load("image/kumo.png")
kumosmall = Sprite.new(700,100,kumo)
kumosmall.scale_x = 0.5
kumosmall.scale_y = 0.5

kumosmall2 = Sprite.new(100,200,kumo)
kumosmall2.scale_x = 0.5
kumosmall2.scale_y = 0.5

Window.loop do
    # 背景を水色に塗りつぶす
    Window.draw_box_fill(0, 0, Window.width, Window.height, [173, 216, 230])

    # 背景の下部に緑の領域をウィンドウの幅いっぱいに塗りつぶす
    green_area_height = 150
    green_area_y = Window.height - green_area_height
    Window.draw_box_fill(0, green_area_y, Window.width, Window.height, [0, 255, 0])
   
    #雲の表示
    brack_height = 100
    Window.draw_box_fill(5, 5, Window.width - 5, 95, [0, 0, 0])
    Window.draw_box_fill(10,10, 1190,90, [255, 255, 255])
    kumosmall2.draw
    kumosmall.draw

    
    count = count + 1
    player.draw
    obstacle.draw
    obstacle.update

    Window.draw_font(100, y2 + count, "#{obstacle.status[:damage]}", obstacle_font)
    Window.draw_font(300, 350, "#{player.status[:health]}", player_font)

    player.update
    Sprite.check(player, obstacle)

    # ループの終了条件
    break if Input.key_push?(K_ESCAPE)

end