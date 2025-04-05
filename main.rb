require_relative 'catalog'

def add_book(catalog)
  print "Enter title: "
  title = (gets || "").chomp
  print "Enter author: "
  author = (gets || "").chomp
  print "Enter genre: "
  genre = (gets || "").chomp
  print "Enter publication year (e.g., 2020): "
  year = (gets || "").chomp
  
  if catalog.add_book(title, author, genre, year)
    puts "Book added successfully!"
  else
    puts "❗ Invalid input. Please try again."
  end
end

def remove_book(catalog)
  list_books(catalog)
  print "Enter the number of the book to remove: "
  input = gets
  return puts "No input received." if input.nil?
  
  index = input.chomp.to_i - 1
  removed = catalog.remove_book(index)
  
  if removed
    puts "🗑️ Removed: #{removed}"
  else
    puts "Invalid index."
  end
end

def search_books(catalog)
  print "Search by (title/author/genre): "
  filter = (gets || "").chomp.downcase
  print "Enter search keyword: "
  keyword = (gets || "").chomp.downcase
  
  results = catalog.search_books(filter, keyword)
  
  if results.empty?
    puts "No matching books found."
  else
    puts "\nSearch Results:"
    results.each_with_index { |book, i| puts "#{i + 1}. #{book}" }
  end
end

def report_by_genre(catalog)
  grouped = catalog.books_by_genre
  grouped.each do |genre, books|
    puts "\nGenre: #{genre}"
    books.each_with_index { |book, i| puts " #{i + 1}. #{book}" }
  end
end

def report_by_author(catalog)
  grouped = catalog.books_by_author
  grouped.each do |author, books|
    puts "\nAuthor: #{author}"
    books.each_with_index { |book, i| puts " #{i + 1}. #{book}" }
  end
end

def list_books(catalog)
  if catalog.catalog.empty?
    puts "📭 No books in the catalog."
  else
    puts "\nCurrent Book Catalog:"
    catalog.catalog.each_with_index { |book, i| puts "#{i + 1}. #{book}" }
  end
end

def main_menu
  catalog = Catalog.new
  
  loop do
    puts "\n=== Book Cataloging System ==="
    puts "1. Add Book"
    puts "2. Remove Book"
    puts "3. Search Book"
    puts "4. Report by Genre"
    puts "5. Report by Author"
    puts "6. View All Books"
    puts "0. Exit"
    print "Choose an option: "
    
    input = gets
    if input.nil?
      puts "No input received. Exiting program."
      break
    end
    
    choice = input.chomp.to_i
    
    case choice
    when 1 then add_book(catalog)
    when 2 then remove_book(catalog)
    when 3 then search_books(catalog)
    when 4 then report_by_genre(catalog)
    when 5 then report_by_author(catalog)
    when 6 then list_books(catalog)
    when 0
      puts "Goodbye!"
      break
    else
      puts "Invalid option. Try again."
    end
  end
end

main_menu