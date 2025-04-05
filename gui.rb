require 'tk'
require_relative 'catalog'

catalog = Catalog.new
root = TkRoot.new { title "📚 Book Catalog System" }

# --- Input Frame ---
input_frame = TkFrame.new(root).pack(padx: 10, pady: 10, side: 'top')

TkLabel.new(input_frame) { text 'Title:' }.pack(side: 'left', padx: 5)
title_entry = TkEntry.new(input_frame).pack(side: 'left')

TkLabel.new(input_frame) { text 'Author:' }.pack(side: 'left', padx: 5)
author_entry = TkEntry.new(input_frame).pack(side: 'left')

TkLabel.new(input_frame) { text 'Genre:' }.pack(side: 'left', padx: 5)
genre_entry = TkEntry.new(input_frame).pack(side: 'left')

TkLabel.new(input_frame) { text 'Year:' }.pack(side: 'left', padx: 5)
year_entry = TkEntry.new(input_frame).pack(side: 'left')

# --- Action Buttons Frame ---
button_frame = TkFrame.new(root).pack(pady: 10)

# --- Search Frame ---
search_frame = TkFrame.new(root).pack(pady: 10)
TkLabel.new(search_frame) { text 'Search by:' }.pack(side: 'left')

filter_var = TkVariable.new
TkOptionMenubutton.new(search_frame, filter_var, 'title', 'author', 'genre').pack(side: 'left')
search_entry = TkEntry.new(search_frame).pack(side: 'left', padx: 5)

# --- Reports Frame ---
report_frame = TkFrame.new(root).pack(pady: 10)

# --- Result Display Listbox ---
result_frame = TkFrame.new(root).pack(padx: 10, pady: 10)
result_list = TkListbox.new(result_frame) do
  width 100
  height 15
  selectmode 'single'
end.pack(side: 'left')

scrollbar = TkScrollbar.new(result_frame) do
  orient 'vertical'
  command proc { |*args| result_list.yview(*args) }
end.pack(side: 'right', fill: 'y')
result_list.yscrollcommand(proc { |first, last| scrollbar.set(first, last) })

# --- Refresh Function ---
refresh_result_list = proc {
  result_list.delete(0, 'end')
  catalog.catalog.each_with_index do |book, index|
    result_list.insert('end', "#{index + 1}. #{book}")
  end
}

# --- Add Book Button ---
TkButton.new(button_frame) {
  text 'Add Book'
  command {
    begin
      title  = title_entry.value.strip
      author = author_entry.value.strip
      genre  = genre_entry.value.strip
      year   = year_entry.value.strip

      success = catalog.add_book(title, author, genre, year)

      if success
        refresh_result_list.call
      else
        result_list.insert('end', "⚠️ Invalid input. Title, Author, Genre required and Year must be 4 digits.")
      end
    rescue => e
      result_list.insert('end', "Error: #{e.message}")
    end
  }
}.pack(side: 'left', padx: 5)

# --- Remove Selected Book ---
TkButton.new(button_frame) {
  text 'Remove Selected'
  command {
    begin
      selected_index = result_list.curselection.first
      if selected_index
        removed = catalog.remove_book(selected_index)
        if removed
          refresh_result_list.call
        else
          result_list.insert('end', "⚠️ Failed to remove the selected book.")
        end
      else
        result_list.insert('end', "⚠️ Please select a book to remove.")
      end
    rescue => e
      result_list.insert('end', "Error: #{e.message}")
    end
  }
}.pack(side: 'left', padx: 5)

# --- Search Button ---
TkButton.new(search_frame) {
  text 'Search'
  command {
    result_list.delete(0, 'end')
    filter = filter_var.value.strip.downcase
    keyword = search_entry.value.strip

    results = catalog.search_books(filter, keyword)
    if results.any?
      results.each_with_index do |book, index|
        result_list.insert('end', "#{index + 1}. #{book}")
      end
    else
      result_list.insert('end', "No matching books found.")
    end
  }
}.pack(side: 'left', padx: 5)

# --- Report by Genre Button ---
TkButton.new(report_frame) {
  text 'Report by Genre'
  command {
    result_list.delete(0, 'end')
    grouped = catalog.books_by_genre
    grouped.each do |genre, books|
      result_list.insert('end', "📚 Genre: #{genre}")
      books.each { |book| result_list.insert('end', "  - #{book}") }
      result_list.insert('end', "")
    end
  }
}.pack(side: 'left', padx: 5)

# --- Report by Author Button ---
TkButton.new(report_frame) {
  text 'Report by Author'
  command {
    result_list.delete(0, 'end')
    grouped = catalog.books_by_author
    grouped.each do |author, books|
      result_list.insert('end', "✍️ Author: #{author}")
      books.each { |book| result_list.insert('end', "  - #{book}") }
      result_list.insert('end', "")
    end
  }
}.pack(side: 'left', padx: 5)

# --- Start the Tk main loop ---
Tk.mainloop
