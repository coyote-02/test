class Player < Sprite
    attr_accessor :status

    def initialize(x, y, image)
        @status = {
            health: 100,
            speed: 10
        }
        @invulnerable = false
        super(x, y, image)
    end

    def update
        self.y += Input.y
        if @invulnerable
            # 一定時間後に無敵状態を解除
            @invulnerable = false
        end
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