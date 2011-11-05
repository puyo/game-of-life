require 'set'

module Life
  class Universe
    attr_reader :live_positions

    def initialize(live_positions = [])
      self.live_positions = live_positions
    end

    def tick!
      potential_birth_positions = Set.new
      next_live_positions = live_positions.select do |position|
        live_neighbours, dead_neighbours = neighbours(position)
        potential_birth_positions.merge dead_neighbours
        live_neighbours.size == 2 or live_neighbours.size == 3
      end
      next_live_positions += potential_birth_positions.select do |position| 
        neighbours(position).first.count == 3
      end
      self.live_positions = next_live_positions
      return self
    end

    def live?(position)
      @is_alive[position]
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
      @live_positions = positions
      build_is_alive_hash
    end

    def build_is_alive_hash
      @is_alive = Hash.new(false)
      @live_positions.each{|position| @is_alive[position] = true }
    end
  end
end

if $0 == __FILE__
  def render(universe)
    xs, ys = universe.live_positions.transpose
    (ys.min..ys.max).each do |y|
      (xs.min..xs.max).each do |x|
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
