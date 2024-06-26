class Player < Sprite
    attr_accessor :status

    def initialize(x, y, image)
        @status = {
            health_h: $num_vertical_hs,
            health_v: $num_vertical_vs,
            speed: 4 
        }
        @invulnerable = false
        super(x, y, image)
    end

    def update
        self.y += Input.y * 4
        if self.y < 100
            self.y = 100
        end

        if self.y > 570
            self.y = 570
        end

        if @invulnerable
            # 一定時間後に無敵状態を解除
            @invulnerable = false
        end

    end

    def reset_status
        # プレイヤーのステータスをリセット
        @status = {
            health_h: $num_vertical_hs,
            health_v: $num_vertical_vs,
            speed: 4
        }
    end

    def total_health
        $num_vertical_hs + $num_vertical_vs
    end

    def shot(obstacle_or_heal)
        unless @invulnerable
            if obstacle_or_heal.is_a?(Obstacle_h)
                # Obstacleの場合はダメージを与える
                puts "Before damage_h: #{@status[:health_h]}"
                $num_vertical_hs -= obstacle_or_heal.status[:damage_h]
                puts "After damage_h: #{@status[:health_h]}"
            elsif obstacle_or_heal.is_a?(Obstacle_v)
                # Obstacleの場合はダメージを与える
                puts "Before damage_v: #{@status[:health_v]}"
                $num_vertical_vs -= obstacle_or_heal.status[:damage_v]
                puts "After damage_v: #{@status[:health_v]}"
            elsif obstacle_or_heal.is_a?(Heal_v)
                # Healの場合は回復を行う
                puts "Before heal_v: #{@status[:health_v]}"
                $num_vertical_vs += obstacle_or_heal.status[:heal_v]
                puts "After heal_v: #{@status[:health_v]}"
            elsif obstacle_or_heal.is_a?(Heal_h)
                # Healの場合は回復を行う
                puts "Before heal_h: #{@status[:health_h]}"
                $num_vertical_hs += obstacle_or_heal.status[:heal_h]
                puts "After heal_h: #{@status[:health_h]}"
            elsif obstacle_or_heal.is_a?(Obstaclespeed)
                # Obstaclespeedの場合は速度を減少させる
                puts "Before speed: #{@status[:speed]}"
                @status[:speed] *= obstacle_or_heal.status[:slow] * 0.25 #変更点
                @status[:speed] = [[@status[:speed], 0.5].max, 16].min
                puts "After speed: #{@status[:speed]}"
            elsif obstacle_or_heal.is_a?(Boss)
                puts "Boss detected!!!!"
                # Bossの場合は合計ヘルスからダメージを減らす
                total_damage = obstacle_or_heal.status[:damage_boss]
                remaining_damage = total_damage

                if $num_vertical_hs >= remaining_damage
                    $num_vertical_vs -= remaining_damage
                else
                    remaining_damage -= $num_vertical_hs
                    $num_vertical_hs = 0
                    [$num_vertical_vs = $num_vertical_vs - remaining_damage, 0].max
                end

                # 合計ヘルスが0以下になった場合の画面遷移
                if total_health <= 0
                    $screen = CONTINUE
                elsif total_health > 0
                    $screen = CLEAR
                end

            end
            @invulnerable = true
        end
    end
    
end