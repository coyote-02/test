class Player < Sprite
    attr_accessor :status, :bullets

    def initialize(x, y, image)
        @status = {
            health: 100,
            speed: 2 
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
            elsif obstacle_or_heal.is_a?(Obstaclespeed)
                # Obstaclespeedの場合は速度を減少させる
                puts "Before speed: #{@status[:speed]}"
                @status[:speed] *= obstacle_or_heal.status[:slow] * 0.25 #変更点
                puts "After speed: #{@status[:speed]}"
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