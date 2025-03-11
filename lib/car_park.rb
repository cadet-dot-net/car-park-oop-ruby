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

    alter_spot(choose_spot_type(vehicle), :add)
  end

  def leave(vehicle)
    return unless vehicle.class.include?(Vehicle)

    alter_spot(choose_spot_type(vehicle), :remove)
  end

  private

  def alter_spot(spot_type, action)
    return nil unless spot_type
    amount = @@spot_type_size[spot_type]

    case action
    when :add then @spots[spot_type] -= amount
    when :remove then @spots[spot_type] += amount
    end
    
    spot_type
  end

  def choose_spot_type(vehicle)
    vehicle.spot_types.each do |spot_type|
      spot_size = @@spot_type_size[spot_type]
      spots_left = @spots[spot_type]
      
      if spots_left >= spot_size
        return spot_type
      end
    end

    return nil
  end
end
