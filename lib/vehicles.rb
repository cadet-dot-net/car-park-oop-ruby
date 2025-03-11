# frozen_string_literal: true

# Namespace - Vehicle module with vehicle classes
module Vehicle
  attr_reader :space_type

  @@vehicle_space_types = {
    car: %i[compact regular],
    motorcycle: :compact,
    van: :large
  }

  # Representation of a car object
  class Car
    include Vehicle

    def initialize
      @space_type = @@vehicle_space_types[:car].sample
    end
  end

  # Representation of a car object
  class Motorcycle
    include Vehicle

    def initialize
      @space_type = @@vehicle_space_types[:motorcycle]
    end
  end

  # Representation of a van object
  class Van
    include Vehicle

    def initialize
      @space_type = @@vehicle_space_types[:van]
    end
  end
end
