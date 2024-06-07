require 'dxruby'
require_relative "obstacle"
require_relative "player"
require_relative "heal"
require_relative "bullet"

# ウィンドウのサイズを設定
Window.width = 1200
Window.height = 700

# 画面の状態
TITLE = 0
RULE = 1 
LEVEL = 2
EASY = 3
NOMAL = 4
HARD = 5

screen = TITLE
re = 0


kumo = Image.load("image/kumo.png")
kumosmall = Sprite.new(700,100,kumo)

kumosmall.scale_x = 0.5
kumosmall.scale_y = 0.5

kumosmall2 = Sprite.new(100,200,kumo)

kumosmall2.scale_x = 0.5
kumosmall2.scale_y = 0.5

#障害物

obstacle_img = Image.load("image/enemy.png")
obstacle_img = Image.load("image/player.png")

x1 = 100
y1 = 100

count = 0

obstacle_img = Image.load("image/enemy.png")
obstacles = []
15.times do
    obstacles << Obstacle.new(rand(-500..900),rand(100..700),obstacle_img)
end

obstacle_font = Font.new(32)

#主人公
player_img = Image.load("image/player.png")
player_x = 1100
player_y = 325
player = Player.new(player_x, player_y, player_img)
player_font = Font.new(32)


#アイテム
heal_img = Image.load("image/チェスの無料アイコン.png")
heals = []
15.times do
    heal = Heal.new(rand(-500..300),rand(100..900),heal_img)
    heals << heal
end

heal_font = Font.new(32)



#背景下準備
kumo = Image.load("image/kumo.png")
kumosmall = Sprite.new(700,100,kumo)
kumosmall.scale_x = 0.5
kumosmall.scale_y = 0.5

kumosmall2 = Sprite.new(100,200,kumo)
kumosmall2.scale_x = 0.5
kumosmall2.scale_y = 0.5

select = Image.new(900,150,[240,230,140])
chenge = Image.new(900,150,[238,232,170])
select1 = Sprite.new(150,75,select)
select2 = Sprite.new(150,275,select)
select3 = Sprite.new(150,475,select)


#フォント
font_size = 150
 font = Font.new(font_size,"Algerian")


Window.loop do
    case screen
    when TITLE
     Window.draw_box_fill(0, 0, Window.width, Window.height, [144, 238, 144])
     Window.draw_font(100, 100, "title_text", Font.default)
     if Input.key_push?(K_SPACE)
        screen = RULE
     end
    when RULE
        Window.draw_box_fill(0, 0, Window.width, Window.height, [144, 238, 144]) 
        Window.draw_font(100, 100, "rule_text", Font.default)
        if Input.key_push?(K_SPACE)
            screen = LEVEL
     end
    when LEVEL
     Window.draw_box_fill(0, 0, Window.width, Window.height, [144, 238, 144])
     select1.draw
     select2.draw
     select3.draw
    
     if Input.key_push?(K_1)
        re = 1
     end

     if Input.key_push?(K_2)
        re = 2
     end

     if Input.key_push?(K_3)
        re = 3
     end

     if re == 1
        select1.image = chenge
        if Input.key_push?(K_SPACE)
            screen = EASY
        end
     else
        select1.image = select
     end

     if re == 2
        select2.image = chenge
        if Input.key_push?(K_SPACE)
            screen = NOMAL
        end
     else
        select2.image = select
     end

     if re == 3
        select3.image = chenge
        if Input.key_push?(K_SPACE)
            screen = HARD
        end
     else
        select3.image = select
     end
     Window.draw_font(150,75,"EASY",font)
     Window.draw_font(150,275,"NOMAL",font)
     Window.draw_font(150,475,"HARD",font)
    when EASY

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


    count += 1

    #障害物
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

    #回復アイテム
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

    #主人公

    
    count = count + 1

    player.draw
    player.update

    puts "Player Health: #{player.status[:health]}" if Input.key_push?(K_RETURN)

    #弾丸
    player.bullets.each(&:draw)
    player.bullets.each(&:update)
    
    

    # ループの終了条件
    break if Input.key_push?(K_ESCAPE)
end


end

#弾丸
#bullet_image = Image.load("image/明度アイコン.png")
#bullet_x = player_x
#bullet_y = player_y
#bullet = Bullet.new(bullet_x,bullet_y,bullet_image)

# プレイヤーの弾と障害物の衝突処理
    #Sprite.check(player.bullets, obstacles)