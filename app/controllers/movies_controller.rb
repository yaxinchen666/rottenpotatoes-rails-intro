class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings

    is_redirect = false
    if params.include?('ratings')
      session[:ratings] = @ratings_to_show = params['ratings'].keys
    elsif session.include?(:ratings)
      params['ratings'] = session[:ratings].to_h{|r| [r, 1]}
      is_redirect = true
    else
      @ratings_to_show = @all_ratings
    end
    if params.include?('sort_column')
      session[:sort_column] = @sort_column = params['sort_column']
    elsif session.include?(:sort_column)
      params['sort_column'] = session[:sort_column]
      is_redirect = true
    else
      @sort_column = nil
    end
    if is_redirect
      redirect_to movies_path(params)
    end

    @movies = Movie.sort_with_ratings(@sort_column, @ratings_to_show)
    # logger.debug "#{params}" # params['ratings']: {'G'=>1}
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
