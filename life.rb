require 'set'

module Life
  class Universe
    def initialize(live_positions = [])
      self.live_positions = live_positions
    end

    def tick!
      potential_birth_positions = Set.new
      next_live_positions = live_positions.select{|position|
        live_neighbours, dead_neighbours = neighbours(position)
        potential_birth_positions.merge dead_neighbours
        live_neighbours.size == 2 or live_neighbours.size == 3
      }
      next_live_positions.concat(potential_birth_positions.select{|position| 
        neighbours(position).first.count == 3
      })
      self.live_positions = next_live_positions
      return self
    end

    def live?(position)
      @live_positions.include?(position)
    end

    def live_positions
      @live_positions.to_a
    end

    private

    NEIGHBOUR_OFFSETS = [
      [-1,-1], [0,-1], [1,-1],
      [-1, 0],         [1, 0],
      [-1, 1], [0, 1], [1, 1],
    ]

    # Live neighbours and dead neighbours in two arrays.
    def neighbours(position)
      lives, deads = [], []
      NEIGHBOUR_OFFSETS.each do |dx, dy|
        nposition = [position[0] + dx, position[1] + dy]
        (live?(nposition) ? lives : deads) << nposition
      end
      return lives, deads
    end

    def live_positions=(positions)
      @live_positions = Set.new(positions)
    end
  end
end

if $0 == __FILE__
  def render(universe)
    xs, ys = universe.live_positions.transpose.map{|series| series.min..series.max }
    ys.each do |y|
      xs.each do |x|
        print universe.live?([x, y]) ? 'o' : '.'
      end
      puts
    end
    puts
  end

  acorn = [[1,0], [3,1], [0,2], [1,2], [4,2], [5,2], [6,2]]
  universe = Life::Universe.new(acorn)
  loop do
    render(universe)
    sleep 0.5
    universe.tick!
  end
end
