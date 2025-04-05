require_relative 'book'

class Catalog
  attr_reader :catalog
  
  def initialize
    @catalog = []
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