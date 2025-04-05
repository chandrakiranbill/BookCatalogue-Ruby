require_relative 'book'

class CatalogSystem
  attr_reader :catalog
  
  def initialize
    @catalog = []
    # Add sample books shown in screenshots
    @catalog << Book.new("Concepts of Programming Languages, 12th Edition", "Robert W. Sebesta", "textbook", "2025")
    @catalog << Book.new("The grass is Always Greener", "Jeffrey Archer", "Novel", "2020")
    @catalog << Book.new("A boy at seven", "steven", "novel", "2021")
  end
  
  def add_book(title, author, genre, year)
    if title.empty? || author.empty? || genre.empty? || year !~ /^\d{4}$/
      return false
    end
    
    @catalog << Book.new(title, author, genre, year)
    true
  end
  
  def remove_book(index)
    if index >= 0 && index < @catalog.length
      removed = @catalog.delete_at(index)
      return removed
    end
    nil
  end
  
  def search_books(filter, keyword)
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