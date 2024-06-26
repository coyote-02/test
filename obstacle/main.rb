require 'dxruby'
require_relative "obstacle_h"
require_relative "obstacle_v"
require_relative "player"
require_relative "heal_v"
require_relative "heal_h"
require_relative "obstaclespeed"
require_relative "boss"
require_relative "vertical_v"
require_relative "vertical_h"

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
CONTINUE = 7
CLEAR = 8


$screen = TITLE
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

background_image = Image.load("image/war.png")
gatya_image = Image.load("image/ガチャピン.png")

logo = Image.load("image/logo.jpg")
logo = Sprite.new(100,-220,logo) 

#障害物
count = 0

obstacle_v_img = Image.load("image/damage.png")
obstacle_vs = []
obstacle_v_n = 4
obstacle_v_font = Font.new(32)
obstacle_h_img = Image.load("image/damage2.png")
obstacle_hs = []
obstacle_h_n = 4
obstacle_h_font = Font.new(32)

#障害物(スピード)

obstaclespeed_img = Image.load("image/damage.png")
obstaclespeeds = []
obstaclespeed_font = Font.new(32)

#主人公
player_img = Image.load("image/coyote.png")
player_x = 1000
player_y = 325
player = Player.new(player_x, player_y, player_img)
player_font = Font.new(32)

#vertical_v
vertical_v_img = Image.load("image/player.png")
vertical_v_x = 1000
vertical_v_y = 325

# 生成するvertical_vオブジェクトの数を設定
$num_vertical_vs = 100
$num_vertical_hs = 100

def create_vertical_vs(num, vertical_v_x, vertical_v_y, img, max_per_column = 20)
  vertical_vs = []
  
  # 各オブジェクトの間隔を定義（例：50ピクセル）
  spacing = 15
  column_spacing = 15 # 列間の間隔

  num.times do |i|
    column = i / max_per_column
    row = i % max_per_column
    x = vertical_v_x + column * column_spacing
    y = vertical_v_y + row * spacing
    vertical_vs << Vertical_v.new(x, y, img)
  end
  vertical_vs
end

# vertical_vオブジェクトを生成
vertical_vs = create_vertical_vs($num_vertical_vs, vertical_v_x, vertical_v_y, vertical_v_img)

# 画面の幅と高さを取得（例としてWindow.widthとWindow.heightを使用）
screen_width = Window.width
screen_height = Window.height

#vertical_h
vertical_h_img = Image.load("image/player.png")
vertical_h_x = 950
vertical_h_y = 370

def create_vertical_hs(num, vertical_h_x, vertical_h_y, img, max_per_row = 15)
  vertical_hs = []
  
  # 各オブジェクトの間隔を定義（例：12ピクセル）
  spacing = 15
  row_spacing = 15 # 行間の間隔
  
  num.times do |i|
    row = i / max_per_row
    column = i % max_per_row
    x = vertical_h_x + column * spacing
    y = vertical_h_y + row * row_spacing
    vertical_hs << Vertical_h.new(x, y, img)
  end
  vertical_hs
end

# vertical_hオブジェクトを生成
vertical_hs = create_vertical_hs($num_vertical_hs, vertical_h_x, vertical_h_y, vertical_h_img)


#アイテム
heal_v_img = Image.load("image/kaihuku.png")
heal_vs = []

heal_v_font = Font.new(32)

heal_h_img = Image.load("image/kaihuku.png")
heal_hs = []

heal_h_font = Font.new(32)

# Boss の設定
boss_img = Image.load("image/raion.png")
boss_font = Font.new(72)
boss_x = -300
boss_y = 100
boss = Boss.new(boss_x, boss_y, boss_img)
start_time = nil

# オブジェクトが重ならない位置を見つける関数
def find_non_overlapping_position_v(existing_objects, width, height)
  loop do
    x = rand(0..600)
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
    x = rand(0..600)
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
4.times do
  x, y = find_non_overlapping_position_h(obstacle_hs + obstaclespeeds + heal_hs, obstaclespeed_img.width, obstaclespeed_img.height)
  obstaclespeeds << Obstaclespeed.new(x, y, obstaclespeed_img)
end

4.times do
  x, y = find_non_overlapping_position_v(obstacle_vs + obstaclespeeds + heal_vs, obstaclespeed_img.width, obstaclespeed_img.height)
  obstaclespeeds << Obstaclespeed.new(x, y, obstaclespeed_img)
end
  
# アイテムを初期配置
4.times do
  x, y = find_non_overlapping_position_v(obstacle_vs + obstaclespeeds + heal_vs, heal_v_img.width, heal_v_img.height)
  heal_vs << Heal_v.new(x, y, heal_v_img)
end

4.times do
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
font3_size = 100
font3_size = Font.new(font3_size,"HGS創英角ﾎﾟｯﾌﾟ体")
font4_size = 40
font4_size = Font.new(font4_size,"游明朝")

font_size_count = 500
font_count = Font.new(font_size_count, "UD デジタル 教科書体 NP-B")
count_space = 0

Window.loop do
    case $screen
    when TITLE
     Window.draw_box_fill(0, 0, Window.width, Window.height, [144, 238, 144])
     Window.draw_font(200, 300, "コヨーテ・ウォーズ", font3_size)
     logo.draw

     # 透明度の計算（0から255の範囲で変化させる）
     alpha = (Math.sin(count_space * 0.05) * 128 + 127).to_i

     Window.draw_font_ex(450, 600, "- Press Space -", font1,color:[255,255,255,alpha])

     count_space += 1

     if Input.key_push?(K_SPACE)
        $screen = RULE
     end
    when RULE
        Window.draw_box_fill(0, 0, Window.width, Window.height, [144, 238, 144]) 
        Window.draw_font(100, 100, "コヨーテを上下に動かして、ボスまでの体力をつけよう！", Font.default)
        Window.draw_font(100, 150, "ボスを倒してゲームクリア！", Font.default)
        Window.draw_font(100, 200, "アイテム", font1)
        Window.draw_font(100, 250, "加速", font4_size)
        Window.draw_font(100, 300, "減速", font4_size) 
        Window.draw_font(100, 350, "回復", font4_size) 
        Window.draw_font(100, 400, "ダメージ", font1)
        Window.draw_font(100, 450, "縦ダメージ", font4_size)
        Window.draw_font(100, 500, "横ダメージ", font4_size)
        if Input.key_push?(K_SPACE)
            $screen = LEVEL
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

     if re == 1 or re == 2 or re == 3
         # 透明度の計算（0から255の範囲で変化させる）
         alpha = (Math.sin(count_space * 0.05) * 128 + 127).to_i

         Window.draw_font_ex(450, 630, "- Press Space -", font1,color:[255,255,255,alpha])

         count_space += 1
     end

     if re == 1
        select1.image = chenge
        if Input.key_push?(K_SPACE)
          countdown_start = Time.now
          $screen = COUNTDOWN
        end
     else
        select1.image = select
     end

     if re == 2
        select2.image = chenge
        if Input.key_push?(K_SPACE)
          countdown_start = Time.now
          $screen = COUNTDOWN
        end
     else
        select2.image = select
     end

     if re == 3
        select3.image = chenge
        if Input.key_push?(K_SPACE)
          countdown_start = Time.now
          $screen = COUNTDOWN
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
            $screen = EASY
        elsif re == 2
            $screen = NOMAL
        elsif re == 3
            $screen = HARD
        end        
    end

  when EASY
    initial_set_time = 30
    set_time = initial_set_time
    unless start_time
      start_time = Time.now
    end
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

    #プレイヤーの初期化
    $player = Player.new(player_x, player_y, player_img)

    Window.draw_font(800, 35, "縦：#{$num_vertical_vs}", obstacle_h_font, color: [119, 136, 153])
    Window.draw_font(1000, 35, "横：#{$num_vertical_hs }", obstacle_h_font, color: [255, 150, 45])

    obstacle_vs.each do |obstacle_v|
      obstacle_v.draw
      obstacle_v.update(player)
      font_x = obstacle_v.x + 30
      font_y = obstacle_v.y + 30
      # 外枠を描画
      4.times do |dx|
        4.times do |dy|
          Window.draw_font(font_x + dx - 2, font_y + dy - 2, "- #{obstacle_v.status[:damage_v] }", obstacle_v_font, color: [0, 0, 0])
        end
      end
      Window.draw_font(font_x, font_y, "- #{obstacle_v.status[:damage_v] }", obstacle_v_font, color: [119, 136, 153])
    end

    obstacle_hs.each do |obstacle_h|
      obstacle_h.draw
      obstacle_h.update(player)
      font_x = obstacle_h.x + 30
      font_y = obstacle_h.y + 30
      # 外枠を描画
      4.times do |dx|
        4.times do |dy|
          Window.draw_font(font_x + dx - 2, font_y + dy - 2, "- #{obstacle_h.status[:damage_h] }", obstacle_h_font, color: [0, 0, 0])
        end
      end
      Window.draw_font(font_x, font_y, "- #{obstacle_h.status[:damage_h] }", obstacle_h_font, color: [255, 150, 45])
    end

    # オブスタクルとの衝突判定と処理
    obstacle_vs.reject! do |obstacle_v|
      collision = Sprite.check(player, obstacle_v)
      if collision
        puts "Collision detected!"
        puts "Player Health_v: #{$num_vertical_vs}"
        vertical_vdamage = obstacle_v.status[:damage_v] / 10
        $num_vertical_vs -= vertical_vdamage
        # 0未満にならないようにする
        $num_vertical_vs = [$num_vertical_vs, 0].max 
        # 現在のvertical_vオブジェクトをクリアして再生成
        vertical_vs.each(&:vanish)
        vertical_vs.clear
        vertical_vs = create_vertical_vs($num_vertical_vs, vertical_v_x, vertical_v_y, vertical_v_img)
        true
      elsif obstacle_v.x > Window.width
        true
      else
        false
      end
    end

    # vertical_vオブジェクトの描画と更新
    Sprite.update(vertical_vs)
    Sprite.draw(vertical_vs)

    # vertical_hオブジェクトの描画と更新
    Sprite.update(vertical_hs)
    Sprite.draw(vertical_hs)

    obstacle_hs.reject! do |obstacle_h|
      collision = Sprite.check(player, obstacle_h)
      if collision
        puts "Collision detected!"
        puts "Player Health_h: #{$num_vertical_hs}"
        vertical_h_hdamage = obstacle_h.status[:damage_h] / 10
        $num_vertical_hs -= vertical_h_hdamage
        # 0未満にならないようにする
        $num_vertical_hs = [$num_vertical_hs, 0].max 
        puts "Num vertical_hs: #{$num_vertical_hs}"
        # 現在のvertical_hオブジェクトをクリアして再生成
        vertical_hs.each(&:vanish)
        vertical_hs.clear
        vertical_hs = create_vertical_hs($num_vertical_hs, vertical_h_x, vertical_h_y, vertical_h_img)
        true
      elsif obstacle_h.x > Window.width
        true
      else
        false
      end
    end

    if obstacle_vs.size < 4
      (4 - obstacle_vs.size).times do
        x, y = find_non_overlapping_position_v(obstacle_vs + obstaclespeeds + heal_vs, obstacle_v_img.width, obstacle_v_img.height)
        obstacle_vs << Obstacle_v.new(x, y, obstacle_v_img)
      end
    end

    if obstacle_hs.size < 4
      (4 - obstacle_hs.size).times do
        x, y = find_non_overlapping_position_h(obstacle_hs + obstaclespeeds + heal_hs, obstacle_h_img.width, obstacle_h_img.height)
        obstacle_hs << Obstacle_h.new(x, y, obstacle_h_img)
      end
    end

    #vertical_v
    vertical_vs.each do |vertical_v|
      vertical_v.draw
      vertical_v.update
    end

    #vertical_h
    vertical_hs.each do |vertical_h|
      vertical_h.draw
      vertical_h.update
    end

    #障害物(スピード)
    obstaclespeeds.each do |obstaclespeed|
      obstaclespeed.draw
      obstaclespeed.update(player)
      font_x = obstaclespeed.x + 25
      font_y = obstaclespeed.y + 30
      # 外枠を描画
      4.times do |dx|
        4.times do |dy|
          Window.draw_font(font_x + dx - 2, font_y + dy - 2, "#{obstaclespeed.status[:slow] * 0.25}", obstaclespeed_font, color: [0, 0, 0])
        end
      end
      Window.draw_font(font_x, font_y, "#{obstaclespeed.status[:slow] *0.25}", obstaclespeed_font) 
    end

    # 右端に出た障害物(スピード)を削除
    obstaclespeeds.reject! do |obstaclespeed|
      if player === Sprite.check(player, obstaclespeed)
          true
      elsif obstaclespeed.x > Window.width
          true
      else
          false
      end
    end

    if obstaclespeeds.size < 4
      (4 - obstaclespeeds.size).times do
        x, y = find_non_overlapping_position_h(obstacle_hs + obstaclespeeds + heal_hs, obstaclespeed_img.width, obstaclespeed_img.height)
        obstaclespeeds << Obstaclespeed.new(x, y, obstaclespeed_img)
      end
    end

    if obstaclespeeds.size < 4
      (4 - obstaclespeeds.size).times do
        x, y = find_non_overlapping_position_v(obstacle_vs + obstaclespeeds + heal_vs, obstaclespeed_img.width, obstaclespeed_img.height)
        obstaclespeeds << Obstaclespeed.new(x, y, obstaclespeed_img)
      end
    end

    #回復アイテム
    heal_vs.each do |heal_v|
      heal_v.draw
      heal_v.update(player)
      font_x = heal_v.x
      font_y = heal_v.y
      # 外枠を描画
      4.times do |dx|
        4.times do |dy|
          Window.draw_font(font_x +23, font_y +23, "#{heal_v.status[:heal_v] }", heal_v_font, color: [0, 0, 0])
        end
      end
      Window.draw_font(font_x +25, font_y +25, "#{heal_v.status[:heal_v] }", heal_v_font, color: [119, 136, 153])
    end

    heal_hs.each do |heal_h|
      heal_h.draw
      heal_h.update(player)
      font_x = heal_h.x
      font_y = heal_h.y
      # 外枠を描画
      4.times do |dx|
        4.times do |dy|
          Window.draw_font(font_x +23, font_y +23, "#{heal_h.status[:heal_h] }", heal_h_font, color: [0, 0, 0])
        end
      end
      Window.draw_font(font_x +25, font_y +25, "#{heal_h.status[:heal_h] }", heal_h_font, color: [255, 150, 45])
    end

    # 右端に出た回復アイテムを削除
    heal_vs.reject! do |heal_v|
      collision = Sprite.check(player, heal_v)
      if collision
        puts "Collision detected!"
        puts "Player Health_v: #{$num_vertical_vs}"
        vertical_vheal = heal_v.status[:heal_v] / 10
        $num_vertical_vs += vertical_vheal
        # 0未満にならないようにする
        $num_vertical_vs = [$num_vertical_vs, 0].max 
        # 現在のvertical_vオブジェクトをクリアして再生成
        vertical_vs.each(&:vanish)
        vertical_vs.clear
        vertical_vs = create_vertical_vs($num_vertical_vs, vertical_v_x, vertical_v_y, vertical_v_img)
        true
      elsif heal_v.x > Window.width
        true
      else
        false
      end
    end

    heal_hs.reject! do |heal_h|
      collision = Sprite.check(player, heal_h)
      if collision
        puts "Collision detected!"
        puts "Player Health_h: #{$num_vertical_hs}"
        vertical_h_hheal = heal_h.status[:heal_h] / 10
        $num_vertical_hs += vertical_h_hheal
        # 0未満にならないようにする
        $num_vertical_hs = [$num_vertical_hs, 0].max 
        puts "Num vertical_hs: #{$num_vertical_hs}"
        # 現在のvertical_hオブジェクトをクリアして再生成
        vertical_hs.each(&:vanish)
        vertical_hs.clear
        vertical_hs = create_vertical_hs($num_vertical_hs, vertical_h_x, vertical_h_y, vertical_h_img)
        true
      elsif heal_h.x > Window.width
        true
      else
        false
      end
    end

    if heal_vs.size < 4
      (4 - heal_vs.size).times do
        x, y = find_non_overlapping_position_v(obstacle_vs + obstaclespeeds + heal_vs, heal_v_img.width, heal_v_img.height)
        heal_vs << Heal_v.new(x, y, heal_v_img)
      end
    end

    if heal_hs.size < 4
      (4 - heal_hs.size).times do
        x, y = find_non_overlapping_position_h(obstacle_hs + obstaclespeeds + heal_hs, heal_h_img.width, heal_h_img.height)
        heal_hs << Heal_h.new(x, y, heal_h_img)
      end
    end

    #主人公
    player.draw
    player.update

    puts "Player Health_v: #{$num_vertical_vs}" if Input.key_push?(K_RETURN)
    puts "Player Health_h: #{$num_vertical_hs}" if Input.key_push?(K_RETURN)

    #ボスの出現・その処理
    difference_time = start_time ? Time.now - start_time : 0
    boss_time = [set_time - difference_time.to_i, 0].max

    font_color = boss_time <= 10 ? [255, 0, 0] : [0, 0, 0]
    Window.draw_font(500, 30, "ボスまであと: #{boss_time}秒", player_font, color: font_color)
    Window.draw_font(100, 30, "ボスの強さ: #{boss.status[:damage_boss]}", player_font, color: [0, 0, 0])

    if boss_time <= 0
      boss.update(player)
      boss.draw
      font_x = boss.x + 25
      font_y = boss.y + 30
      # 外枠を描画
      Window.draw_font(font_x + 33, font_y + 183, "- #{boss.status[:damage_boss] }", boss_font, color: [0, 0, 0])
      Window.draw_font(font_x + 35, font_y + 185, "- #{boss.status[:damage_boss] }", boss_font, color: [119, 136, 153])
    end

    if player === Sprite.check(player, boss)
      puts "Player : #{player.total_health}"
      true
    elsif boss.x > Window.width
      true
    else
      false
    end

    #応急処置の脱出
    if $num_vertical_hs <= 0 || $num_vertical_vs <= 0
      $screen = CONTINUE
    end

    # ループの終了条件
    break if Input.key_push?(K_ESCAPE)
    

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

  when CONTINUE
    #リセット処理
    player.reset_status()
    $num_vertical_vs = 100
    $num_vertical_hs = 100
    obstacle_vs.clear
    obstacle_hs.clear
    obstaclespeeds.clear
    heal_vs.clear
    heal_hs.clear
    boss = Boss.new(boss_x, boss_y, boss_img)
    boss.reset_position(0, 350)
    start_time = nil
    set_time = initial_set_time

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
          $screen = EASY
        end
        if re == 2
          $screen = NOMAL
        end
        if re == 3
          $screen = HARD
        end
      end
    else
      put_sato1.image = sato
    end

    if move == 2
      put_sato2.image = chenge_sato
      if Input.key_push?(K_SPACE)
        $screen = LEVEL
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
    Window.draw_font(475,500,"難易度選択\nに戻る",font1)
    Window.draw_font(900,500,"終わる",font1)

  when CLEAR
    #リセット処理
    player.reset_status()
    $num_vertical_vs = 100
    $num_vertical_hs = 100
    obstacle_vs.clear
    obstacle_hs.clear
    obstaclespeeds.clear
    heal_vs.clear
    heal_hs.clear
    boss = Boss.new(boss_x, boss_y, boss_img)
    boss.reset_position(0, 350)
    start_time = nil
    set_time = initial_set_time

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
          $screen = EASY
        end
        if re == 2
          $screen = NOMAL
        end
        if re == 3
          $screen = HARD
        end
      end
    else
      put_sato1.image = sato
    end

    if move == 2
      put_sato2.image = chenge_sato
      if Input.key_push?(K_SPACE)
        $screen = LEVEL
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

    Window.draw_font(130,200,"GAME CLEAR🎉",font2)
    Window.draw_font(130,500,"もう一度",font1)
    Window.draw_font(475,500,"難易度選択\nに戻る",font1)
    Window.draw_font(900,500,"終わる",font1)

  end
end