# Use the code from last week's tasks to complete this:
# eg: 6.2, 3.1T

module Genre
    POP, CLASSIC, JAZZ, ROCK = *1..4
end
  
$genre_names = ['Null', 'Pop', 'Classic', 'Jazz', 'Rock']
  
class Album
  # NB: you will need to add tracks to the following and the initialize()
      attr_accessor :title, :artist, :year, :image
  
  # complete the missing code:
      def initialize (title, artist, year, image)
          # insert lines here
          @title = title
          @artist = artist
          @year = year
          @image = image
      end
end
  
class Track
      attr_accessor :name, :location
  
      def initialize (name, location)
          @name = name
          @location = location
      end
end
  
  # Reads in and returns a single track from the given file
  
def read_track(music_file)
      # fill in the missing code
      track_name = music_file.gets().chomp()
      track_location = music_file.gets().chomp()
      track = Track.new(track_name, track_location)
      return track
end
  
  # Returns an array of tracks read from the given file
  
def read_tracks(music_file)
      
      count = music_file.gets().to_i()
      tracks = Array.new()
    # Put a while loop here which increments an index to read the tracks
      index =0
      while index<count
      track=read_track(music_file)
      tracks<<track
      index += 1
    end
  
      return tracks
end
  
  # Takes an array of tracks and prints them to the terminal
  
def print_tracks(tracks)
      # print all the tracks use: tracks[x] to access each track.
      index =0
        times = tracks.length
        while (index < times)
          print_track(tracks[index])
          index+=1
      end
end
  
  # Reads in and returns a single album from the given file, with all its tracks
  
def read_album(music_file)
  
    # read in all the Album's fields/attributes including all the tracks
    # complete the missing code
      album_title = music_file.gets.chomp()
      album_artist = music_file.gets.chomp()
      album_year = music_file.gets.chomp()
      album_image = music_file.gets.chomp()
      album = Album.new(album_title, album_artist, album_year, album_image)
      return album
end
  
  
  # Takes a single album and prints it to the terminal along with all its tracks
def print_album(album)
  
    # print out all the albums fields/attributes
    # Complete the missing code.
    puts('' + album.title)
    puts('' + album.artist)
    puts('Genre is ' + album.genre.to_s)
    puts $genre_names[album.genre]
      # print out the tracks
  
end
  
  # Takes a single track and prints it to the terminal
def print_track(track)
    puts( track.name)
    puts( track.location)
end

#Read multiple albums
def read_albums(path_to_text)
        music_file = File.new(path_to_text, 'r')
        count = music_file.gets().to_i()
        albums = Array.new()
  # Put a while loop here which increments an index to read the tracks
        index =0
        while index<count
            album = read_album(music_file)
            tracks = read_tracks(music_file)
            albums << {"id" => index, "album" => album, "tracks" => tracks}
            index += 1
        end
        return albums;

end
