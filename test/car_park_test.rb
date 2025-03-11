require 'minitest/autorun'
require_relative '../lib/car_park'
require_relative '../lib/vehicles'

describe 'CarPark' do
  describe 'new' do
    it 'creates instance with arguments' do
      assert_instance_of CarPark, CarPark.new
    end

    it 'raises if arguments are given' do
      assert_raises(ArgumentError) { CarPark.new('test') }
    end

    it 'sets size to sum of available spots' do
      car_park = CarPark.new
      assert_equal({ compact: 30, regular: 50, large: 20 }, car_park.spots)
      assert_equal 100, car_park.size
    end
  end

  describe 'state' do
    before do
      @car_park = CarPark.new
    end

    it 'returns :empty when no spots are filled' do
      assert_equal :empty, @car_park.state
    end

    it 'returns :full when all spots are filled' do
      @car_park.instance_variable_set(:@spots, { compact: 0, regular: 0, large: 0 })
      assert_equal :full, @car_park.state
    end

    it 'returns :occcupied when 1 or more spots are filled' do
      @car_park.instance_variable_set(:@spots, { compact: 29, regular: 50, large: 20 })
      assert_equal :occupied, @car_park.state
    end
  end

  describe 'park' do
    before do
      @car_park = CarPark.new
      @original_spots = @car_park.spots.dup
    end

    it 'returns vehicle spot type' do
      assert_equal :large, @car_park.park(Vehicle::Van.new)
    end

    it 'returns true unless parking a non-vehicle' do
      assert @car_park.park(Vehicle::Car.new)
      refute @car_park.park(Object.new)
      refute @car_park.park(nil)
    end

    it 'deducts a spot when a vehicle is parked' do
      car = Vehicle::Car.new
      original_spots_sum = @original_spots.values.sum

      @car_park.park(car)
      assert_equal original_spots_sum - 1, @car_park.spots.values.sum
    end

    it 'returns false when parking lot is full' do
      @car_park.instance_variable_set(:@spots, { compact: 0, regular: 0, large: 0 })
      refute @car_park.park(Vehicle::Car.new)
    end
  
    it 'returns false when specific spot type is full' do
      @car_park.instance_variable_set(:@spots, { compact: 30, regular: 50, large: 0 })
      refute @car_park.park(Vehicle::Van.new)  # Motorcycles need compact spots
    end

    it 'parks vehicles in their preferred spot types when available' do
      assert_equal :compact, @car_park.park(Vehicle::Motorcycle.new)  
      assert_equal :regular, @car_park.park(Vehicle::Car.new)  
      assert_equal :large, @car_park.park(Vehicle::Van.new)  

      assert_equal @original_spots.values.sum - 3, @car_park.spots.values.sum
    end

    it 'parks vehicles in their next preferred spot types when the first type is unavailable' do
      @car_park.instance_variable_set(:@spots, { compact: 30, regular: 0, large: 20 })
      original_compact_spots = @car_park.spots[:compact]
      original_spots_sum = @car_park.spots.values.sum

      assert_equal :compact, @car_park.park(Vehicle::Car.new)
      assert_equal original_compact_spots - 1, @car_park.spots[:compact]
      assert_equal original_spots_sum - 1, @car_park.spots.values.sum
    end

    it 'returns nil when no suitable spots are available' do
      @car_park.instance_variable_set(:@spots, { compact: 0, regular: 0, large: 0 })
      
      refute @car_park.park(Vehicle::Motorcycle.new)
      refute @car_park.park(Vehicle::Car.new)
      refute @car_park.park(Vehicle::Van.new)
    end

    it 'maintains state consistency on failed parking' do
      @car_park.instance_variable_set(:@spots, { compact: 0, regular: 1, large: 1 })
      original_state = @car_park.spots.dup
      
      refute @car_park.park(Vehicle::Motorcycle.new)
      assert_equal original_state, @car_park.spots
    end
  end
end
