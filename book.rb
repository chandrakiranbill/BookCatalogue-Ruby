class Book
  attr_accessor :title, :author, :genre, :year
  
  def initialize(title, author, genre, year)
    @title = title
    @author = author
    @genre = genre
    @year = year.to_s
  end
  
  def to_s
    "#{title} by #{author} (#{genre}, #{year})"
  end
end