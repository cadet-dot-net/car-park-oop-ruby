# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/spec'
require_relative '../lib/vehicles'

describe 'Vehicle' do
  it 'provides spot_types reader to included classes' do
    assert_respond_to Vehicle::Car.new, :spot_types
    assert_respond_to Vehicle::Motorcycle.new, :spot_types
    assert_respond_to Vehicle::Van.new, :spot_types
  end

  describe 'Car' do
    it 'can park in regular and compact spots' do
      car = Vehicle::Car.new
      assert_equal [:regular, :compact], car.spot_types
    end
  end

  describe 'Motorcycle' do
    it 'can park in compact, regular, and large spots' do
      motorcycle = Vehicle::Motorcycle.new
      assert_equal [:compact, :regular, :large], motorcycle.spot_types
    end
  end

  describe 'Van' do
    it 'can only park in large spots' do
      van = Vehicle::Van.new
      assert_equal [:large], van.spot_types
    end
  end
end
