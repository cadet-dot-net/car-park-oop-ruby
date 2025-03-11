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
      @car_park.instance_variable_set(:@spots, { compact: 0, regular: 50, large: 20 })
      refute @car_park.park(Vehicle::Motorcycle.new)  # Motorcycles need compact spots
    end

    it 'assigns vehicle to spot type' do
      compact_spots = @original_spots[:compact]
      regular_spots = @original_spots[:regular]
      large_spots = @original_spots[:large]

      @car_park.park(Vehicle::Motorcycle.new)
      assert_equal({
        compact: compact_spots - 1,
        regular: regular_spots,
        large: large_spots
      }, @car_park.spots)

      @car_park.park(Vehicle::Van.new)
      assert_equal({
        compact: compact_spots - 1,
        regular: regular_spots,
        large: large_spots - 1
      }, @car_park.spots)

      car = Vehicle::Car.new
      car.instance_variable_set(:@space_type, :regular)
      @car_park.park(car)
      assert_equal({ 
        compact: compact_spots - 1, 
        regular: regular_spots - 1, 
        large: large_spots - 1 
      }, @car_park.spots)
    end

    it 'maintains state consistency on failed parking' do
      @car_park.instance_variable_set(:@spots, { compact: 0, regular: 1, large: 1 })
      original_state = @car_park.spots.dup
      
      refute @car_park.park(Vehicle::Motorcycle.new)
      assert_equal original_state, @car_park.spots
    end
  end
end
