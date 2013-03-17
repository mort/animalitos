module Siblings
  module Traits
    module Moves
      attr_reader :positions

      def move_to(location, options = {})
        raise 'Supply a location' unless location.is_a?(Location)
        return false if (current_location && location === current_location)

        leave_current_location if current_location
        enter_location(location, options)
      end

      def current_position
        positions.last
      end

      def current_location
        current_position.location unless current_position.nil?
      end

      def enter_location(location, options = {})
    
        pos = Position.new(location, self, options)

        positions << pos

        changed
    
        notify_observers pos.as_activity if self.is_a?(Animalito)

        location
      end

      def leave_current_location
        current_location.remove_occupant(self)
      end
  
    end

  end
end