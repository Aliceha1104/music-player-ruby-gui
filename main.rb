# Add library
require 'gosu'
require './track_handler'

module ZOrder
    BACKGROUND, MIDDLE, TOP = *0..2
end

module State
    PLAYING, PAUSING, STOPPING, NEXT_TRACK, PREV_TRACK = *8..12
end

$state = ["Now playing:", "Pausing at:", "Stopping at"]

module AlbumsSelector
    FIRST, SECOND, THIRD, FOURTH = *0..3
end

module TrackSelector
    FIRST, SECOND, THIRD, FOURTH = *4..7
end

class MusicPlayer < Gosu::Window
    def initialize(width, height, is_full_screen, title)
        super(width, height, is_full_screen)
        @font = Gosu::Font.new(13)
        self.caption = title
        @albums = read_albums("./text.txt")
        @album_selector = 0
        @track_selector = 0
        @album_images = []
        @albums.each { |album| @album_images << Gosu::Image.new(album["album"].image) }
        @state = nil
        @arrow = Gosu::Image.new("./images/arrow.png")
        @volume_bar_width = 200
    end

    def draw_background
        Gosu.draw_rect(0, 0, width, height, 0xff_D8D3D1, ZOrder::BACKGROUND, mode = :default)
        # @font.draw("mX: #{mouse_x}\nmY: #{mouse_y}", width / 2, height - 100, ZOrder::MIDDLE, 1.0, 1.0, Gosu::Color::BLACK)
    end

    def draw_album_images
        @album_images.each_with_index do |album_image, index|
            x = index.even? ? 50 : 230
            y = index < 2 ? 80 : 270
            album_image.draw(x, y, ZOrder::TOP, 0.15, 0.15)
        end
    end

    def draw_tracks
        if @album_selector >= 0 && @album_selector <= 3
            init_x = 500
            init_y = 80
            @albums[@album_selector]["tracks"].each do |track|
                @font.draw(track.name, init_x, init_y, ZOrder::TOP, 2.0, 2.0, Gosu::Color::BLACK)
                init_y += 40
            end
            case @track_hover
            when TrackSelector::FIRST
                @arrow.draw(init_x - 40, 80, ZOrder::TOP, 0.05, 0.05)
            when TrackSelector::SECOND
                @arrow.draw(init_x - 40, 120, ZOrder::TOP, 0.05, 0.05)
            when TrackSelector::THIRD
                @arrow.draw(init_x - 40, 160, ZOrder::TOP, 0.05, 0.05)
            when TrackSelector::FOURTH
                @arrow.draw(init_x - 40, 200, ZOrder::TOP, 0.05, 0.05)
            end
        end
    end

    def mouse_hover?(mouse_x, mouse_y)
        if (mouse_x >= 50 && mouse_x <= 393) && (mouse_y >= 80 && mouse_y <= 433)
            if (mouse_x >= 50 && mouse_x <= 213) && (mouse_y >= 80 && mouse_y <= 243)
                return AlbumsSelector::FIRST
            elsif (mouse_x >= 230 && mouse_x <= 393) && (mouse_y >= 80 && mouse_y <= 243)
                return AlbumsSelector::SECOND
            elsif (mouse_x >= 50 && mouse_x <= 213) && (mouse_y >= 270 && mouse_y <= 433)
                return AlbumsSelector::THIRD
            elsif (mouse_x >= 230 && mouse_x <= 393) && (mouse_y >= 270 && mouse_y <= 433)
                return AlbumsSelector::FOURTH
            end
        end

        if (mouse_x >= 490 && mouse_x <= 800) && (mouse_y >= 85 && mouse_y <= 235)
            if (mouse_y >= 85 && mouse_y <= 105)
                return TrackSelector::FIRST
            elsif (mouse_y >= 125 && mouse_y <= 145)
                return TrackSelector::SECOND
            elsif (mouse_y >= 165 && mouse_y <= 185)
                return TrackSelector::THIRD
            elsif (mouse_y >= 205 && mouse_y <= 225)
                return TrackSelector::FOURTH
            end
        end
    end

    def draw_player
        if @track_selector >= TrackSelector::FIRST && @track_selector <= TrackSelector::FOURTH
            track_index = @track_selector - TrackSelector::FIRST
            track_name = @albums[@album_selector]["tracks"][track_index].name
            @font.draw("#{$state[@state - 8]}\n#{track_name}", 500, 320, ZOrder::TOP, 2.0, 2.0, Gosu::Color::BLACK)
            @font.draw("Volume: #{(@song.volume * 100).round(0)}%", 500, 420, ZOrder::TOP, 2.0, 2.0, Gosu::Color::BLACK)

            volume_bar_x = 500
            volume_bar_y = 450
            volume_bar_fill_width = @volume_bar_width * @song.volume
            Gosu.draw_rect(volume_bar_x, volume_bar_y, volume_bar_fill_width, 10, Gosu::Color::GREEN, ZOrder::TOP)
            Gosu.draw_rect(volume_bar_x, volume_bar_y, @volume_bar_width, 10, Gosu::Color::GRAY, ZOrder::TOP, mode = :add)
        end
    end

    #////////////////////////////// GOSU::WINDOW FUNCTIONS //////////////////////////////////////////
    def draw
        draw_background
        draw_album_images
        draw_tracks
        draw_player
    end

    def update
    end

    def need_cursor?
        true
    end

    def button_down(id)
        case id
        when Gosu::MsLeft
            case mouse_hover?(mouse_x, mouse_y)
            when AlbumsSelector::FIRST
                puts("Choose album 1")
                if defined?(@song)
                    @song.stop()
                    @album_selector = AlbumsSelector::FIRST
                else
                    @album_selector = AlbumsSelector::FIRST
                end
            when AlbumsSelector::SECOND
                puts("Choose album 2")
                if defined?(@song)
                    @song.stop()
                    @album_selector = AlbumsSelector::SECOND
                else
                    @album_selector = AlbumsSelector::SECOND
                end
            when AlbumsSelector::THIRD
                puts("Choose album 3")
                if defined?(@song)
                    @song.stop()
                    @album_selector = AlbumsSelector::THIRD
                else
                    @album_selector = AlbumsSelector::THIRD
                end
            when AlbumsSelector::FOURTH
                puts("Choose album 4")
                if defined?(@song)
                    @song.stop()
                    @album_selector = AlbumsSelector::FOURTH
                else
                    @album_selector = AlbumsSelector::FOURTH
                end
            when TrackSelector::FIRST
                @track_selector = TrackSelector::FIRST
                @album_tracks = @albums[@album_selector]["tracks"]
                @track_location = @album_tracks[@track_selector - 4].location
                @song = Gosu::Song.new(@track_location)
                @song.play(false)
                @state = State::PLAYING
                @track_hover = @track_selector
            when TrackSelector::SECOND
                @track_selector = TrackSelector::SECOND
                @album_tracks = @albums[@album_selector]["tracks"]
                @track_location = @album_tracks[@track_selector - 4].location
                @song = Gosu::Song.new(@track_location)
                @song.play(false)
                @state = State::PLAYING
                @track_hover = @track_selector
            when TrackSelector::THIRD
                @track_selector = TrackSelector::THIRD
                @album_tracks = @albums[@album_selector]["tracks"]
                @track_location = @album_tracks[@track_selector - 4].location
                @song = Gosu::Song.new(@track_location)
                @song.play(false)
                @state = State::PLAYING
                @track_hover = @track_selector
            when TrackSelector::FOURTH
                @track_selector = TrackSelector::FOURTH
                @album_tracks = @albums[@album_selector]["tracks"]
                @track_location = @album_tracks[@track_selector - 4].location
                @song = Gosu::Song.new(@track_location)
                @song.play(false)
                @state = State::PLAYING
                @track_hover = @track_selector
            end

        when Gosu::KbP
            @song.play(false)
            @state = State::PLAYING
        when Gosu::KbS
            @song.stop()
            @state = State::STOPPING
        when Gosu::KbA
            @song.pause()
            @state = State::PAUSING
        when Gosu::KbRight
            if @track_selector - 4 < @album_tracks.length - 1
                @track_selector += 1
                @track_location = @album_tracks[@track_selector - 4].location
                @song = Gosu::Song.new(@track_location)
                @song.play(false)
                @state = State::PLAYING
                @track_hover = @track_selector
            else
                @track_selector = TrackSelector::FIRST
                @track_location = @album_tracks[@track_selector - 4].location
                @song = Gosu::Song.new(@track_location)
                @song.play(false)
                @state = State::PLAYING
                @track_hover = @track_selector
            end
        when Gosu::KbLeft
            if @track_selector - 4 > 0
                @track_selector -= 1
                @track_location = @album_tracks[@track_selector - 4].location
                @song = Gosu::Song.new(@track_location)
                @song.play(false)
                @state = State::PLAYING
                @track_hover = @track_selector
            else
                @track_selector = TrackSelector::FOURTH
                @track_location = @album_tracks[@track_selector - 4].location
                @song = Gosu::Song.new(@track_location)
                @song.play(false)
                @state = State::PLAYING
                @track_hover = @track_selector
            end
        when Gosu::KbUp
            @song.volume = @song.volume + 0.05
        when Gosu::KbDown
            @song.volume = @song.volume - 0.05
        end
    end


end

MusicPlayer.new(800, 600, false, "Music Player").show