module Motivation
  class Mote
    include MoteLike

    def prepare!
      require!
    end

    def constant
      name.camelize(:upper).safe_constantize
    end
  end
end
