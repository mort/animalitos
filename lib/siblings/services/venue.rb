module Siblings
  module Services
    class Venue < OpenStruct
      
      include Streamable::Venue
      
      def initialize(venue_hash)
        super venue_hash
      end
      
    end
  end
end