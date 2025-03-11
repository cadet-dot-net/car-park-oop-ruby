# frozen_string_literal: true

# Namespace - Vehicle module with vehicle classes
module Vehicle
  attr_reader :spot_types

  # Representation of a car object
  class Car
    include Vehicle

    def initialize
      @spot_types = %i[regular compact]
    end
  end

  # Representation of a car object
  class Motorcycle
    include Vehicle

    def initialize
      @spot_types = %i[compact regular large]
    end
  end

  # Representation of a van object
  class Van
    include Vehicle

    def initialize
      @spot_types = %i[large]
    end
  end
end
