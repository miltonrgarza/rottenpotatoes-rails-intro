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
    @all_ratings = Movie.all_ratings
    
    if !params[:sort].nil?
      @sorting = params[:sort]
    else
      @sorting = session[:sort]
    end
    
    if params[:ratings].kind_of? Hash
      params[:ratings] = params[:ratings].keys
    else
      params[:ratings] = params[:ratings]
    end
    
    if !params[:ratings].nil?
      @filter = params[:ratings]
      @ratings = params[:ratings]
    else !session[:ratings].nil?
      @filter = session[:ratings]
      @ratings = session[:ratings]
    end
    
    @movies = Movie.where(rating: @ratings).order(@sorting)
    if (params[:sort].nil? && !session[:sort].nil?) || (params[:ratings].nil? && !session[:ratings].nil?)
      flash.keep
      redirect_to movies_path(sort: @sorting,ratings: @ratings)
    end
    
    session[:ratings] = @ratings
    session[:sort] = @sorting
    
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
