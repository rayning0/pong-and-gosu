class Pause < State
    def initialize game, old_state
        @game = game
        @screen = game.screen
        @queue = game.queue
        @old_state = old_state
        
        @text = Text.new 0, 0, "Paused", 100
        @text.center_x @screen.width
        @text.center_y @screen.height
    end
    
    def update
        @queue.each do |ev|
            case ev
                when Rubygame::KeyDownEvent
                    if ev.key == Rubygame::K_P or ev.key == Rubygame::K_ESCAPE
                        @game.switch_state @old_state
                    end
            end
        end
    end
    
    def draw
        @screen.fill [0, 0, 0]
        
        @text.draw @screen
        
        @screen.flip
    end
end