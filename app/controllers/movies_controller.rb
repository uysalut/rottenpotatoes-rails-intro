class MoviesController < ApplicationController
  before_action :set_checked

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    if params[:title_sorted]
      @movies = Movie.order(title: :asc)
      @title = "hilite"
    elsif params[:date_sorted]
      @movies = Movie.order(release_date: :asc)
      @date = "hilite"
    elsif params[:ratings]
      @movies = Movie.where(rating: params[:ratings].keys)
      @all_ratings.each do |r|
        if params[:ratings].keys.include? r 
          @checked[r] = true
        else
          @checked[r] = false
        end
      end
    else
      @movies = Movie.all
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
  
  def set_checked
    @all_ratings = Movie.get_ratings
    @checked = {'G' => true, 'PG' => true, 'PG-13' => true, 'R' => true}
  end
  
    

end
