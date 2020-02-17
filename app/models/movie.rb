class Movie < ActiveRecord::Base
    def self.get_ratings() # why does it not work
        return self.find_by_sql("SELECT distinct rating from movies")
    end
end
