class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date, :sort_by)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    @movies = Movie.all
    @all_ratings = Movie.get_rating_list
    
    session[:filtered_rating] = params[:ratings] if !params[:ratings].nil?
    
    @movies.where!(rating: session[:filtered_rating].keys) if !session[:filtered_rating].nil?
    
    case params[:sort_by]
    when 'title'
      @movies.order!('title asc')
    when 'release_date'
      @movies.order!('release_date asc')
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

  def find_class(header)
    params[:sort_by] == header ? 'hilite' : ""
  end
  helper_method :find_class

  def check_box_setup(rating)
    return session[:filtered_rating].nil? || session[:filtered_rating].include?(rating)
  end
  helper_method :check_box_setup

end
