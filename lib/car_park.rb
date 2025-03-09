class CarPark
  attr_reader :spots
  attr_reader :size

  def initialize(size)
    @size = size
    @spots = Array.new(@size, nil)
  end

  def get_available_spots
    @spots.select(&:nil?)
  end

  def get_unavailable_spots
    @spots.compact
  end
  
  def get_state
    case self.get_available_spots
    when @size then :empty
    when 0 then :full
    when 0...@size then :occupied
    end
  end

  def park(vehicle_type)
    spaces = spaces_by_vehicle_type(vehicle_type)
    new_spots = @spots

    new_spots.prepend(spaces)
  end

  # private

  def spaces_by_vehicle_type(vehicle_type)
    spaces =
      case vehicle_type
      when :motorcycle then 1
      when :car then 2
      when :van then 3
      end

    (1..spaces).map { |space| [vehicle_type, space] }
  end
end
