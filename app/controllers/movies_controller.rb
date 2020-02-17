class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # get unique rating values from database
    @all_ratings = []
    Movie.get_ratings().each do |obj|
      @all_ratings.append(obj.rating)
    end
    
    # determine if it's a new session by checking if params are all empty
    if (not params[:sort_by]) and (not params[:ratings])
      session.delete(:ratings)
      session.delete(:sort_by)
    end
    
    # initialize session info for default rating filter
    if not session[:ratings]
      session[:ratings] = @all_ratings
    end
    
    @selected_ratings = @all_ratings # initialize to all ratings
    if params[:ratings] # handle rating filter
      @selected_ratings = params[:ratings].keys
      @movies = Movie.where(:rating=>@selected_ratings)
      session[:selected_ratings] = @selected_ratings # store filter into session
    else
      @movies = Movie.where(:rating=>session[:selected_ratings]) # use default filter stored in session
    end
    
    @sort_by = params[:sort_by]
    if @sort_by # handle sorting
      @movies = @movies.order(@sort_by)
      session[:sort_by] = @sort_by
    else
      @movies = @movies.order(session[:sort_by]) # use default sorting
    end
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

end
