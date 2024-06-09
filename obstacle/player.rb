class Player < Sprite
    attr_accessor :status, :bullets

    def initialize(x, y, image)
        @status = {
            health_h: 100,
            health_v:100,
            speed: 4 
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

    end

    def shot(obstacle_or_heal)
        unless @invulnerable
            if obstacle_or_heal.is_a?(Obstacle_h)
                # Obstacleの場合はダメージを与える
                puts "Before damage_h: #{@status[:health_h]}"
                @status[:health_h] -= obstacle_or_heal.status[:damage_h]
                puts "After damage_h: #{@status[:health_h]}"
            elsif obstacle_or_heal.is_a?(Obstacle_v)
                # Obstacleの場合はダメージを与える
                puts "Before damage_v: #{@status[:health_v]}"
                @status[:health_v] -= obstacle_or_heal.status[:damage_v]
                puts "After damage_v: #{@status[:health_v]}"
            elsif obstacle_or_heal.is_a?(Heal_v)
                # Healの場合は回復を行う
                puts "Before heal_v: #{@status[:health_v]}"
                @status[:health_v] += obstacle_or_heal.status[:heal_v]
                puts "After heal_v: #{@status[:health_v]}"
            elsif obstacle_or_heal.is_a?(Heal_h)
                # Healの場合は回復を行う
                puts "Before heal_h: #{@status[:health_h]}"
                @status[:health_h] += obstacle_or_heal.status[:heal_h]
                puts "After heal_h: #{@status[:health_h]}"
            elsif obstacle_or_heal.is_a?(Obstaclespeed)
                # Obstaclespeedの場合は速度を減少させる
                puts "Before speed: #{@status[:speed]}"
                @status[:speed] *= obstacle_or_heal.status[:slow] * 0.25 #変更点
                @status[:speed] = [[@status[:speed], 0.5].max, 16].min
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