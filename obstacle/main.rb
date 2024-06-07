require 'dxruby'
require_relative "obstacle"
require_relative "player"
require_relative "heal"
require_relative "bullet"
require_relative "obstaclespeed"
require_relative "boss"

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
count = 0

obstacle_img = Image.load("image/enemy.png")
obstacles = []
obstacle_n = 15
obstacle_font = Font.new(32)

#障害物(スピード)
obstaclespeed_img = Image.load("image/enemy.png")
obstaclespeeds = []
obstaclespeed_font = Font.new(32)

#主人公
player_img = Image.load("image/player.png")
player_x = 1100
player_y = 325
player = Player.new(player_x, player_y, player_img)
player_font = Font.new(32)

#アイテム
heal_img = Image.load("image/チェスの無料アイコン.png")
heals = []

heal_font = Font.new(32)

#残り時間
time_font = Font.new(32)
# ゲーム開始時刻を記録
start_time = Time.now

# Boss の設定
boss_img = Image.load('image/明度アイコン.png') # Boss の画像を指定
boss = nil

# オブジェクトが重ならない位置を見つける関数
def find_non_overlapping_position(existing_objects, width, height)
    loop do
      x = rand(0..Window.width - width)
      y = rand(100..Window.height - height)
      overlapping = existing_objects.any? do |obj|
        obj.x < x + width && obj.x + obj.image.width > x &&
        obj.y < y + height && obj.y + obj.image.height > y
      end
      return [x, y] unless overlapping
    end
  end
  
  # 障害物を初期配置
  obstacle_n.times do
    x, y = find_non_overlapping_position(obstacles + obstaclespeeds + heals, obstacle_img.width, obstacle_img.height)
    obstacles << Obstacle.new(x, y, obstacle_img)
  end
  
  # 障害物(スピード)を初期配置
  15.times do
    x, y = find_non_overlapping_position(obstacles + obstaclespeeds + heals, obstaclespeed_img.width, obstaclespeed_img.height)
    obstaclespeeds << Obstaclespeed.new(x, y, obstaclespeed_img)
  end
  
  # アイテムを初期配置
  10.times do
    x, y = find_non_overlapping_position(obstacles + obstaclespeeds + heals, heal_img.width, heal_img.height)
    heals << Heal.new(x, y, heal_img)
  end
#ここまで変更点


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
   
    brack_height = 100
    Window.draw_box_fill(5,5, Window.width-5,brack_height-5, [0, 0, 0])
   
    Window.draw_box_fill(10,10, 1190,90, [255, 255, 255])

    kumosmall2.draw

    kumosmall.draw

    count += 1

    #障害物
    obstacles.each do |obstacle|
        obstacle.draw
        obstacle.update(player)
        font_x = obstacle.x
        font_y = obstacle.y
        Window.draw_font(font_x, font_y, "#{obstacle.status[:damage] }", obstacle_font)
    end

    #ここから変更点
    obstacles.reject! do |obstacle|
        if player === Sprite.check(player, obstacle)
            puts "Player Health: #{player.status[:health]}"
            true
        elsif obstacle.x > Window.width
            true
        else
            false
        end
    end

    if obstacles.size < 15
        (15 - obstacles.size).times do
          x, y = find_non_overlapping_position(obstacles + obstaclespeeds + heals, obstacle_img.width, obstacle_img.height)
          obstacles << Obstacle.new(x, y, obstacle_img)
        end
      end
    #ここまで変更点

    #障害物(スピード)
    obstaclespeeds.each do |obstaclespeed|
        obstaclespeed.draw
        obstaclespeed.update(player)
        font_x = obstaclespeed.x
        font_y = obstaclespeed.y
        Window.draw_font(font_x, font_y, "#{obstaclespeed.status[:slow] *0.25}", obstaclespeed_font) #変更点
    end

    #ここから変更点
    # 右端に出た障害物(スピード)を削除
    obstaclespeeds.reject! do |obstaclespeed|
        if player === Sprite.check(player, obstaclespeed)
            puts "Player Speed: #{player.status[:speed]}"
            true
        elsif obstaclespeed.x > Window.width
            true
        else
            false
        end
    end

    if obstaclespeeds.size < 15
        (15 - obstaclespeeds.size).times do
          x, y = find_non_overlapping_position(obstacles + obstaclespeeds + heals, obstaclespeed_img.width, obstaclespeed_img.height)
          obstaclespeeds << Obstaclespeed.new(x, y, obstaclespeed_img)
        end
      end
    #ここまで変更点

    #回復アイテム
    heals.each do |heal|
        heal.draw
        heal.update(player)#変更点
        font_x = heal.x
        font_y = heal.y
        Window.draw_font(font_x +25, font_y +25, "#{heal.status[:heal] }", heal_font)
    end

    #ここから変更点
    # 右端に出た回復アイテムを削除
    heals.reject! do |heal|
        if player === Sprite.check(player, heal)
            puts "Player Health: #{player.status[:health]}"
            true
        elsif heal.x > Window.width
            true
        else
            false
        end
    end

    if heals.size < 10
        (15 - heals.size).times do
          x, y = find_non_overlapping_position(obstacles + obstaclespeeds + heals, heal_img.width, heal_img.height)
          heals << Heal.new(x, y, heal_img)
        end
      end
    #ここまで変更点

    Window.draw_font(600, 30, "#{player.status[:health]}", player_font,color: [44,169,225])

    #主人公
    player.draw
    player.update

    puts "Player Health: #{player.status[:health]}" if Input.key_push?(K_RETURN)

    #弾丸
    player.bullets.each(&:draw)
    player.bullets.each(&:update)
    
    #残り時間(変更点)
    current_time = Time.now
    elapsed_time = (current_time - start_time).to_i
    remaining_time = [3 - elapsed_time, 0].max
    font_color = remaining_time <= 15 ? [255, 0, 0] : [0, 0, 0]
    Window.draw_font(300, 30, "ボスまであと: #{remaining_time}秒", time_font,color: font_color)

    # Boss の出現
    if remaining_time == 0 && boss.nil?
        x, y = find_non_overlapping_position(obstacles + obstaclespeeds + heals + [player], boss_img.width, boss_img.height)
        boss = Boss.new(0,600, boss_img)
      end

    boss&.draw
    boss&.update(player)

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