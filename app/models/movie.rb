class Movie < ActiveRecord::Base
    def self.get_rating_list
        pluck('DISTINCT rating').sort!
    end
end
