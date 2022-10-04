class Movie < ActiveRecord::Base
  def self.with_ratings(ratings_list)
  # if ratings_list is an array such as ['G', 'PG', 'R'], retrieve all
  #  movies with those ratings
  # if ratings_list is nil or empty, retrieve ALL movies
    if ratings_list.nil? || ratings_list.empty?
      return self.all
    else
      return self.where(rating: ratings_list)
    end
  end

  def self.sort_with_ratings(sort_column, ratings_list)
    movies_with_ratings = self.with_ratings(ratings_list)
    if sort_column.nil?
      return movies_with_ratings
    else
      return movies_with_ratings.order(sort_column)
    end
  end

  def self.all_ratings
    return self.select('rating').distinct.map(&:rating)
  end
end
