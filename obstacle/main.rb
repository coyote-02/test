require 'dxruby'
require_relative "obstacle_h"
require_relative "obstacle_v"
require_relative "player"
require_relative "heal_v"
require_relative "heal_h"
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
COUNTDOWN = 3
EASY = 4
NOMAL = 5
HARD = 6


screen = TITLE
re = 0
move = 0

#カウントダウンの時間
countdown_time = 3
countdown_start = nil

kumo = Image.load("image/kumo.png")
kumosmall = Sprite.new(700,100,kumo)

kumosmall.scale_x = 0.5
kumosmall.scale_y = 0.5

kumosmall2 = Sprite.new(100,200,kumo)

kumosmall2.scale_x = 0.5
kumosmall2.scale_y = 0.5

kumo_dark = Image.load("image/kumo_dark.png")
kumo_dark = Sprite.new(700,100,kumo_dark)

kumo_dark.scale_x = 0.5
kumo_dark.scale_y = 0.5

kumo_dark2 = Sprite.new(100,200,kumo_dark)

kumo_dark2.scale_x = 0.5
kumo_dark2.scale_y = 0.5
#障害物
count = 0

obstacle_v_img = Image.load("image/enemy.png")
obstacle_vs = []
obstacle_v_n = 15
obstacle_v_font = Font.new(32)
obstacle_h_img = Image.load("image/enemy.png")
obstacle_hs = []
obstacle_h_n = 15
obstacle_h_font = Font.new(32)

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
heal_v_img = Image.load("image/チェスの無料アイコン.png")
heal_vs = []

heal_v_font = Font.new(32)

heal_h_img = Image.load("image/チェスの無料アイコン.png")
heal_hs = []

heal_h_font = Font.new(32)

#残り時間
time_font = Font.new(32)
# ゲーム開始時刻を記録
start_time = Time.now

# Boss の設定
boss_img = Image.load('image/明度アイコン.png') # Boss の画像を指定
boss = nil

# オブジェクトが重ならない位置を見つける関数
def find_non_overlapping_position_v(existing_objects, width, height)
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

def find_non_overlapping_position_h(existing_objects, width, height)
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
  obstacle_v_n.times do
    x, y = find_non_overlapping_position_v(obstacle_vs + obstaclespeeds + heal_vs, obstacle_v_img.width, obstacle_v_img.height)
    obstacle_vs << Obstacle_v.new(x, y, obstacle_v_img)
  end

  obstacle_h_n.times do
    x, y = find_non_overlapping_position_h(obstacle_hs + obstaclespeeds + heal_hs, obstacle_h_img.width, obstacle_h_img.height)
    obstacle_hs << Obstacle_h.new(x, y, obstacle_h_img)
  end
  
  # 障害物(スピード)を初期配置
  15.times do
    x, y = find_non_overlapping_position_h(obstacle_hs + obstaclespeeds + heal_hs, obstaclespeed_img.width, obstaclespeed_img.height)
    obstaclespeeds << Obstaclespeed.new(x, y, obstaclespeed_img)
  end

  15.times do
    x, y = find_non_overlapping_position_v(obstacle_vs + obstaclespeeds + heal_vs, obstaclespeed_img.width, obstaclespeed_img.height)
    obstaclespeeds << Obstaclespeed.new(x, y, obstaclespeed_img)
  end
  
  # アイテムを初期配置
  10.times do
    x, y = find_non_overlapping_position_v(obstacle_vs + obstaclespeeds + heal_vs, heal_v_img.width, heal_v_img.height)
    heal_vs << Heal_v.new(x, y, heal_v_img)
  end

  10.times do
    x, y = find_non_overlapping_position_h(obstacle_hs + obstaclespeeds + heal_vs, heal_h_img.width, heal_h_img.height)
    heal_hs << Heal_h.new(x, y, heal_h_img)
  end

  #ゲーム背景
def draw_background1(kumosmall, kumosmall2)
  # 背景を水色に塗りつぶす
  Window.draw_box_fill(0, 0, Window.width, Window.height, [173, 216, 230])

  # 背景の下部に緑の領域をウィンドウの幅いっぱいに塗りつぶす
  green_area_height = 150
  green_area_y = Window.height - green_area_height
  Window.draw_box_fill(0, green_area_y, Window.width, Window.height, [0, 255, 0])
            
  #ステータスの枠組み
  brack_height = 100
  Window.draw_box_fill(5,5, Window.width-5,brack_height-5, [0, 0, 0])
  Window.draw_box_fill(10,10, 1190,90, [255, 255, 255])

  #雲
  kumosmall2.draw 
  kumosmall.draw
end


#背景下準備
kumo = Image.load("image/kumo.png")
kumosmall = Sprite.new(700,100,kumo)
kumosmall.scale_x = 0.5
kumosmall.scale_y = 0.5

kumosmall2 = Sprite.new(100,200,kumo)
kumosmall2.scale_x = 0.5
kumosmall2.scale_y = 0.5

kumo_dark = Image.load("image/kumo_dark.png")

kumo_dark = Sprite.new(700,100,kumo_dark)
kumo_dark.scale_x = 0.1
kumo_dark.scale_y = 0.1

kumo_dark2 = Sprite.new(100,200,kumo_dark)
kumo_dark2.scale_x = 0.1
kumo_dark2.scale_y = 0.1

select = Image.new(900,150,[240,230,140])
chenge = Image.new(900,150,[238,232,170])
select1 = Sprite.new(150,75,select)
select2 = Sprite.new(150,275,select)
select3 = Sprite.new(150,475,select)

sato = Image.new(250,100,[240,230,140])
chenge_sato = Image.new(250,100,[238,232,170])
put_sato1 = Sprite.new(100,500,sato)
put_sato2 = Sprite.new(475,500,sato)
put_sato3 = Sprite.new(850,500,sato)

#フォント
font_size = 150
font = Font.new(font_size,"Algerian")
font1_size = 50
font1 = Font.new(font1_size,"MSPゴシック")
font2_size = 150
font2 = Font.new(font2_size,"HGP創英角ﾎﾟｯﾌﾟ体")
font3_size = 100
font3_size = Font.new(font3_size,"HGS創英角ﾎﾟｯﾌﾟ体")


font_size_count = 500
font_count = Font.new(font_size_count, "UD デジタル 教科書体 NP-B")

Window.loop do
    case screen
    when TITLE
     Window.draw_box_fill(0, 0, Window.width, Window.height, [144, 238, 144])
     Window.draw_font(200, 300, "コヨーテ・ウォーズ", font3_size)
     Window.draw_font(500, 500, "Press Space", font1)
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
          countdown_start = Time.now
          screen = COUNTDOWN
        end
     else
        select1.image = select
     end

     if re == 2
        select2.image = chenge
        if Input.key_push?(K_SPACE)
          countdown_start = Time.now
          screen = COUNTDOWN
        end
     else
        select2.image = select
     end

     if re == 3
        select3.image = chenge
        if Input.key_push?(K_SPACE)
          countdown_start = Time.now
          screen = COUNTDOWN
        end
     else
        select3.image = select
     end
     Window.draw_font(150,75,"EASY",font)
     Window.draw_font(150,275,"NOMAL",font)
     Window.draw_font(150,475,"HARD",font)


    when COUNTDOWN

      draw_background1(kumosmall, kumosmall2)

      Window.draw_box_fill(0, 0, Window.width, Window.height, [100, 0, 0, 0])

      elapsed_time = Time.now - countdown_start
      remaining_time = (countdown_time - elapsed_time).ceil
      Window.draw_font(425, 150, "#{remaining_time}", font_count)

      if remaining_time <= 0
          if re == 1
              screen = EASY
          elsif re == 2
              screen = NOMAL
          elsif re == 3
              screen = HARD
          end        
      end

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
     
     #雲
     kumosmall2.draw
     kumosmall.draw

     count += 1
    

    when NOMAL
    
     # 背景を灰色に塗りつぶす
     Window.draw_box_fill(0, 0, Window.width, Window.height, [ 235, 243, 249])
  
     # 背景の下部に茶緑の領域をウィンドウの幅いっぱいに塗りつぶす
     cha_area_height = 200
     cha_area_y = Window.height - cha_area_height
     Window.draw_box_fill(0, cha_area_y, Window.width, Window.height, [ 135, 156, 171])

     brack_height = 100
     Window.draw_box_fill(5,5, Window.width-5,brack_height-5, [0, 0, 0])
   
     Window.draw_box_fill(10,10, 1190,90, [255, 255, 255])

     #雲
     kumo_dark.draw
     kumo_dark2.draw

    
    count += 1
    
    when HARD

     # 背景を濃い灰色に塗りつぶす
     Window.draw_box_fill(0, 0, Window.width, Window.height, [ 192, 192, 192])
  
     # 背景の下部にグレーの領域をウィンドウの幅いっぱいに塗りつぶす
     cha_area_height = 200
     cha_area_y = Window.height - cha_area_height
     Window.draw_box_fill(0, cha_area_y, Window.width, Window.height, [ 105, 105, 105])

     brack_height = 100
     Window.draw_box_fill(5,5, Window.width-5,brack_height-5, [0, 0, 0])
   
     Window.draw_box_fill(10,10, 1190,90, [255, 255, 255])
   

    

     #障害物
    obstacle_vs.each do |obstacle_v|
        obstacle_v.draw
        obstacle_v.update(player)
        font_x = obstacle_v.x
        font_y = obstacle_v.y
        Window.draw_font(font_x, font_y, "#{obstacle_v.status[:damage_v] }", obstacle_v_font)
    end

    obstacle_hs.each do |obstacle_h|
      obstacle_h.draw
      obstacle_h.update(player)
      font_x = obstacle_h.x
      font_y = obstacle_h.y
      Window.draw_font(font_x, font_y, "#{obstacle_h.status[:damage_h] }", obstacle_h_font)
  end

    obstacle_vs.reject! do |obstacle_v|
        if player === Sprite.check(player, obstacle_v)
            puts "Player Health_v: #{player.status[:health_v]}"
            true
        elsif obstacle_v.x > Window.width
            true
        else
            false
        end
    end

    obstacle_hs.reject! do |obstacle_h|
      if player === Sprite.check(player, obstacle_h)
          puts "Player Health_h: #{player.status[:health_h]}"
          true
      elsif obstacle_h.x > Window.width
          true
      else
          false
      end
  end

    if obstacle_vs.size < 15
        (15 - obstacle_vs.size).times do
          x, y = find_non_overlapping_position_v(obstacle_vs + obstaclespeeds + heal_vs, obstacle_v_img.width, obstacle_v_img.height)
          obstacle_vs << Obstacle_v.new(x, y, obstacle_v_img)
        end
      end

    if obstacle_hs.size < 15
      (15 - obstacle_hs.size).times do
        x, y = find_non_overlapping_position_h(obstacle_hs + obstaclespeeds + heal_hs, obstacle_h_img.width, obstacle_h_img.height)
        obstacle_hs << Obstacle_h.new(x, y, obstacle_h_img)
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
          x, y = find_non_overlapping_position_h(obstacle_hs + obstaclespeeds + heal_hs, obstaclespeed_img.width, obstaclespeed_img.height)
          obstaclespeeds << Obstaclespeed.new(x, y, obstaclespeed_img)
        end
      end

    if obstaclespeeds.size < 15
      (15 - obstaclespeeds.size).times do
        x, y = find_non_overlapping_position_v(obstacle_vs + obstaclespeeds + heal_vs, obstaclespeed_img.width, obstaclespeed_img.height)
        obstaclespeeds << Obstaclespeed.new(x, y, obstaclespeed_img)
      end
    end

    #回復アイテム
    heal_vs.each do |heal_v|
        heal_v.draw
        heal_v.update(player)#変更点
        font_x = heal_v.x
        font_y = heal_v.y
        Window.draw_font(font_x +25, font_y +25, "#{heal_v.status[:heal_v] }", heal_v_font)
    end

    heal_hs.each do |heal_h|
      heal_h.draw
      heal_h.update(player)#変更点
      font_x = heal_h.x
      font_y = heal_h.y
      Window.draw_font(font_x +25, font_y +25, "#{heal_h.status[:heal_h] }", heal_h_font)
    end

    #ここから変更点
    # 右端に出た回復アイテムを削除
    heal_vs.reject! do |heal_v|
        if player === Sprite.check(player, heal_v)
            puts "Player Health: #{player.status[:health_v]}"
            true
        elsif heal_v.x > Window.width
            true
        else
            false
        end
    end

    heal_hs.reject! do |heal_h|
      if player === Sprite.check(player, heal_h)
          puts "Player Health: #{player.status[:health_h]}"
          true
      elsif heal_h.x > Window.width
          true
      else
          false
      end
  end

    if heal_vs.size < 10
        (15 - heal_vs.size).times do
          x, y = find_non_overlapping_position_v(obstacle_vs + obstaclespeeds + heal_vs, heal_v_img.width, heal_v_img.height)
          heal_vs << Heal_v.new(x, y, heal_v_img)
        end
      end
    
    if heal_hs.size < 10
      (15 - heal_hs.size).times do
        x, y = find_non_overlapping_position_h(obstacle_hs + obstaclespeeds + heal_hs, heal_h_img.width, heal_h_img.height)
        heal_hs << Heal_h.new(x, y, heal_h_img)
      end
    end

    Window.draw_font(300, 30, "#{player.status[:health_v]}", player_font,color: [44,169,225])
    Window.draw_font(500, 30, "#{player.status[:health_h]}", player_font,color: [44,169,225])

    #主人公
    player.draw
    player.update

    puts "Player Health_v: #{player.status[:health_v]}" if Input.key_push?(K_RETURN)
    puts "Player Health_h: #{player.status[:health_h]}" if Input.key_push?(K_RETURN)
    
    #残り時間(変更点)
    current_time = Time.now
    elapsed_time = (current_time - start_time).to_i
    remaining_time = [3 - elapsed_time, 0].max
    font_color = remaining_time <= 15 ? [255, 0, 0] : [0, 0, 0]
    Window.draw_font(0, 30, "ボスまであと: #{remaining_time}秒", time_font,color: font_color)

    # Boss の出現
    if remaining_time == 0 && boss.nil?
        x, y = find_non_overlapping_position_v(obstacle_vs + obstaclespeeds + heal_vs + [player], boss_img.width, boss_img.height)
        boss = Boss.new(0,600, boss_img)
        boss.scale_x = 10
        boss.scale_y = 10
      end
  
    if remaining_time == 0 && boss.nil?
      x, y = find_non_overlapping_position_h(obstacle_hs + obstaclespeeds + heal_hs + [player], boss_img.width, boss_img.height)
      boss = Boss.new(0,600, boss_img)
      boss.scale_x = 10
      boss.scale_y = 10
    end

    boss&.draw
    boss&.update(player)
    #応急処置の脱出
    if Input.key_push?(K_1)
        screen = CONTENEW
    end    
    # ループの終了条件
    break if Input.key_push?(K_ESCAPE)

    when CONTENEW
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

     # 背景を水色に塗りつぶす
     Window.draw_box_fill(0, 0, Window.width, Window.height, [100,0,0,0])
     
     put_sato1.draw
     put_sato2.draw
     put_sato3.draw

     if Input.key_push?(K_1)
        move = 1
     end

     if Input.key_push?(K_2)
        move = 2
     end

     if Input.key_push?(K_3)
        move = 3
     end

     if move == 1
        put_sato1.image = chenge_sato
        if Input.key_push?(K_SPACE)
           if re == 1 
            screen = EASY
           end
           if re == 2
            screen = NOMAL
           end
           if re == 3
            screen = HARD
           end
        end
     else
        put_sato1.image = sato
     end

     if move == 2
        put_sato2.image = chenge_sato
        if Input.key_push?(K_SPACE)
            screen = LEVEL
        end
     else
        put_sato2.image = sato
     end

     if move == 3
        put_sato3.image = chenge_sato
        if Input.key_push?(K_SPACE)
            break
        end
     else
       put_sato3.image = sato
     end
     Window.draw_font(130,200,"GAME OVER",font2)
     Window.draw_font(130,500,"もう一度",font1)
     Window.draw_font(475,500,"難易度選択
     に戻る",font1)
     Window.draw_font(900,500,"終わる",font1)
end


end

#弾丸
#bullet_image = Image.load("image/明度アイコン.png")
#bullet_x = player_x
#bullet_y = player_y
#bullet = Bullet.new(bullet_x,bullet_y,bullet_image)

# プレイヤーの弾と障害物の衝突処理
    #Sprite.check(player.bullets, obstacles)