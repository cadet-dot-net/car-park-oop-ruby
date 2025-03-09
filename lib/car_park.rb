# frozen_string_literal: true

# Car Park using OOP
class CarPark
  attr_reader :spots, :size

  def initialize(size)
    @size = size
    @spots = Array.new(@size, nil)
  end

  def available_spots
    @spots.select(&:nil?)
  end

  def unavailable_spots
    @spots.compact
  end

  def state
    case available_spots
    when @size then :empty
    when 0 then :full
    when 0...@size then :occupied
    end
  end

  def park(vehicle_type)
    spaces = spaces_by_vehicle_type(vehicle_type)
    new_spots = @spots

    spaces.each {|space| new_spots.unshift(space)}

    # new_spots.unshift(spaces)
  end

  # private

  def spaces_by_vehicle_type(vehicle_type)
    spaces = {
      motorcycle: 1,
      car: 2,
      van: 3
    }

    Array.new(spaces[vehicle_type]) { |i| [vehicle_type, i + 1] }
  end
end
