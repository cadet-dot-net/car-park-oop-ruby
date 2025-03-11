# frozen_string_literal: true

require_relative './vehicles'

# Car Park using OOP
class CarPark
  @@space_types = { compact: 1, regular: 2, large: 3 }

  attr_reader :spots, :size

  def initialize
    @spots = { compact: 30, regular: 50, large: 20 }
    @max_spots = @spots
    @size = @max_spots.values.sum
  end

  def state
    case
    when @spots == @max_spots then :empty
    when @spots.values.all?(0) then :full
    else :occupied
    end
  end

  def park(vehicle)
    return unless vehicle.class.include?(Vehicle)

    space_type = vehicle.space_type
    spot_size = @@space_types[space_type]

    return false if @spots[space_type] < spot_size
    @spots[space_type] -= 1
  end
end
