require 'dxruby'

class Player < Sprite

  @@count = 0
  @@initial_player_position = nil

  def initialize(x, y)
    # プレイヤーの位置とサイズを設定
    image = Image.new(10, 10, [255, 255, 255])
    super(x, y, image)

    if @@initial_player_position.nil?
      @@initial_player_position = [x, y]
    end

    @@count += 1
  end

  def self.initial_player_position
    @@initial_player_position
  end

  def update
    self.x += Input.x
    self.y += Input.y

    # ウィンドウ外に出ないように制限
    self.x = [[self.x, 0].max, Window.width - image.width].min
    self.y = [[self.y, 0].max, Window.height - image.height].min
  end
end

Window.width = 800
Window.height = 600

players = [Player.new(Window.width / 2 - 5, Window.height - 20)]

start_time = Time.now

Window.loop do
  current_time = Time.now
  elapsed_time = current_time - start_time

  # 1秒ごとにプレイヤーを追加し、100秒間増え続ける
  if elapsed_time <= 100 && (elapsed_time.to_i > players.size - 1)
    # 最初に生成されたプレイヤーの周囲に新しいプレイヤーを追加
    initial_x, initial_y = Player.initial_player_position
    new_x = rand(initial_x - 50..initial_x + 50)
    new_y = rand(initial_y - 50..initial_y + 50)
    players << Player.new(new_x, new_y)
  end

  players.each do |player|
    player.update
    player.draw
  end

  # 経過時間の表示
  Window.draw_font(10, 10, "経過時間: #{elapsed_time.to_i}秒", Font.default)
  Window.draw_font(10, 30, "プレイヤー数: #{players.size}", Font.default)

    attr_accessor :status, :bullets

    def initialize(x, y, image)
        @status = {
            health: 100,
            speed: 10
        }
        @invulnerable = false
        @bullets = []
        @bullet_image = Image.load("image/明度アイコン.png")
        super(x, y, image)
    end

    def update
        self.y += Input.y
        if @invulnerable
            # 一定時間後に無敵状態を解除
            @invulnerable = false
        end

        # 弾の発射
        if Input.key_push?(K_SPACE)
            shoot
        end
  
        # 発射された弾の更新
        @bullets.each(&:update)
        @bullets.reject!(&:vanished?)
    end

    def shoot
        bullet = Bullet.new(self.x, self.y, @bullet_image, 10, @status[:health])
        @bullets << bullet
      end
    
      def draw
        super
        @bullets.each(&:draw)
      end



    def shot(obstacle_or_heal)
        unless @invulnerable
            if obstacle_or_heal.is_a?(Obstacle)
                # Obstacleの場合はダメージを与える
                puts "Before damage: #{@status[:health]}"
                @status[:health] -= obstacle_or_heal.status[:damage]
                puts "After damage: #{@status[:health]}"
            elsif obstacle_or_heal.is_a?(Heal)
                # Healの場合は回復を行う
                puts "Before healing: #{@status[:health]}"
                @status[:health] += obstacle_or_heal.status[:heal]
                puts "After healing: #{@status[:health]}"
            end
            @invulnerable = true
        end
    end


end

#@bullets = [] # @bulletsを初期化
        #@bullet_image = Image.load("image/明度アイコン.png") # @bullet_imageを初期化

# 弾の発射
    #if Input.key_push?(K_SPACE)
        #shoot
    #end

    # 発射された弾の更新
    #@bullets.each(&:update)
    #@bullets.reject!(&:vanished?)

#def shoot
    #bullet = Bullet.new(self.x, self.y, @bullet_image)
    #@bullets << bullet
#end

#def draw
    #super
   # @bullets.each(&:draw)
#end