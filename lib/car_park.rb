# frozen_string_literal: true

require_relative './vehicles'

# Car Park using OOP
class CarPark
  @@spot_type_size = { compact: 1, regular: 2, large: 3 }

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
    return if state == :full

    possible_spot_types = vehicle.spot_types
    spot_type = choose_spot_type(possible_spot_types)

    unless spot_type.nil?
      @spots[spot_type] -= 1
      spot_type
    end
  end

  private

  def choose_spot_type(spot_types)
    spot_types.each do |spot_type|
      spot_size = @@spot_type_size[spot_type]
      spots_left = @spots[spot_type]
      
      if spots_left >= spot_size
        return spot_type
      end
    end
    
    return nil
  end
end
