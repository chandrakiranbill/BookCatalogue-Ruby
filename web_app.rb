require 'sinatra'
require_relative 'book'

set :port, 8080
set :bind, '0.0.0.0'
set :protection, except: [:remote_token, :session_hijacking, :json_csrf, :frame_options, :host_authorization]
enable :sessions
set :public_folder, File.dirname(__FILE__) + '/public'
set :environment, :production # Run in production mode to suppress verbose outputs

# Create the catalog system
class WebCatalogSystem
  def initialize
    @catalog = []
    # Add sample books shown in screenshots
    @catalog << Book.new("Concepts of Programming Languages, 12th Edition", "Robert W. Sebesta", "textbook", "2025")
    @catalog << Book.new("The grass is Always Greener", "Jeffrey Archer", "Novel", "2020")
    @catalog << Book.new("A boy at seven", "steven", "novel", "2021")
  end
  
  def get_all_books
    @catalog
  end
  
  def add_book(title, author, genre, year)
    if title.empty? || author.empty? || genre.empty? || year !~ /^\d{4}$/
      return false
    end
    
    @catalog << Book.new(title, author, genre, year)
    true
  end
  
  def remove_book_by_title(title)
    index = @catalog.index { |book| book.title == title }
    if index
      @catalog.delete_at(index)
      return true
    end
    false
  end
  
  def search_books(filter, keyword)
    return [] if filter.nil? || keyword.nil? || keyword.empty?
    
    keyword = keyword.downcase
    
    @catalog.select do |book|
      case filter
      when "title"
        book.title.downcase.include?(keyword)
      when "author"
        book.author.downcase.include?(keyword)
      when "genre"
        book.genre.downcase.include?(keyword)
      else
        false
      end
    end
  end
  
  def books_by_genre
    @catalog.group_by(&:genre)
  end
  
  def books_by_author
    @catalog.group_by(&:author)
  end
end

catalog = WebCatalogSystem.new

# Define routes
get '/' do
  @books = catalog.get_all_books
  erb :index
end

get '/add' do
  erb :add
end

post '/add' do
  title = params[:title]
  author = params[:author]
  genre = params[:genre]
  year = params[:year]
  
  if catalog.add_book(title, author, genre, year)
    session[:success] = "Book \"#{title}\" has been added successfully!"
    redirect '/'
  else
    @error = "Invalid input. Please check all fields."
    erb :add
  end
end

post '/remove' do
  title = params[:title]
  
  if catalog.remove_book_by_title(title)
    session[:success] = "Book has been removed successfully!"
  end
  
  redirect '/'
end

get '/search' do
  @filter = params[:filter]
  @keyword = params[:keyword]
  @searched = !(@filter.nil? || @keyword.nil?)
  
  if @searched
    @results = catalog.search_books(@filter, @keyword)
  else
    @results = []
  end
  
  erb :search
end

get '/report/genre' do
  @books_by_genre = catalog.books_by_genre
  erb :report_genre
end

get '/report/author' do
  @books_by_author = catalog.books_by_author
  erb :report_author
end
