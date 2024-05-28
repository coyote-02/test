require 'dxruby'
require_relative "obstacle"
require_relative "player"
require_relative "buf-item"

# ウィンドウのサイズを設定
Window.width = 1200
Window.height = 700


kumo = Image.load("image/kumo.png")
kumosmall = Sprite.new(700,100,kumo)

kumosmall.scale_x = 0.5
kumosmall.scale_y = 0.5

kumosmall2 = Sprite.new(100,200,kumo)

kumosmall2.scale_x = 0.5
kumosmall2.scale_y = 0.5

#主人公、障害物の設置
count = 0

obstacle_img = Image.load("image/enemy.png")
obstacles = []
15.times do
    obstacles << Obstacle.new(rand(-500..900),rand(0..700),obstacle_img)
end

obstacle_font = Font.new(32)

player_img = Image.load("image/player.png")
player = Player.new(1100, 320, player_img)
player_font = Font.new(32)

#アイテムの設置
heal_img = Image.load("image/チェスの無料アイコン.png")
heals = []
15.times do
    heal = Heal.new(rand(-500..300),rand(0..900),heal_img)
    heals << heal
end

heal_font = Font.new(32)


Window.loop do
    # 背景を水色に塗りつぶす
    Window.draw_box_fill(0, 0, Window.width, Window.height, [173, 216, 230])

    # 背景の下部に緑の領域をウィンドウの幅いっぱいに塗りつぶす
    green_area_height = 150
    green_area_y = Window.height - green_area_height
    Window.draw_box_fill(0, green_area_y, Window.width, Window.height, [0, 255, 0])
   
    brack_height = 100
    Window.draw_box_fill(5,5, Window.width-5,brack_height-5, [0, 0, 0])
   
    Window.draw_box_fill(10,10, 1190,90, [255, 255, 255])

    kumosmall2.draw

    kumosmall.draw

    #障害物、主人公の挙動
    count += 1
    player.draw
    obstacles.each do |obstacle|
        obstacle.draw
        obstacle.update
        font_x = obstacle.x
        font_y = obstacle.y
        Window.draw_font(font_x, font_y, "#{obstacle.status[:damage] }", obstacle_font)
    end

    obstacles.each do |obstacle|
        if player === Sprite.check(player, obstacle)
            puts "Player Health: #{player.status[:health]}"
        end
    end

    heals.each do |heal|
        heal.draw
        heal.update
        font_x = heal.x
        font_y = heal.y
        Window.draw_font(font_x +25, font_y +25, "#{heal.status[:heal] }", heal_font)
    end

    heals.each do |heal|
        if player === Sprite.check(player, heal)
            puts "Player Health: #{player.status[:health]}"
        end
    end

    Window.draw_font(600, 30, "#{player.status[:health]}", player_font,color: [44,169,225])

    player.update

    puts "Player Health: #{player.status[:health]}" if Input.key_push?(K_RETURN)


    # ループの終了条件
    break if Input.key_push?(K_ESCAPE)

end