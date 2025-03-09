require 'minitest/autorun'
require_relative '../lib/car_park'

class CarParkTest < Minitest::Test
  def test_get_all_spots
    assert_equal CarPark.new(3).spots, [nil, nil, nil]
  end
end
