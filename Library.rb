require 'yaml'
require_relative 'Author'
require_relative 'Book'
require_relative 'Reader'
require_relative 'Order'

class Library
  attr_accessor :books, :orders, :readers, :authors
  
  def initialize
    @books = Array.new
	@orders = Array.new
	@readers = Array.new
	@authors = Array.new
  end
  
  def fill_new_order
	  reader = Reader.new("John A", "boijar22@liga.aa", "Chicago", "24 St.", "456")
	  author = Author.new("NameAut", "Biogr")
	  book = Book.new("Title", author)
	  order = Order.new(book, reader, Time.now.to_date)
	  
	  @books << book
	  @readers << reader
	  @authors << author
	  @orders << order
  end
  
  def often_reader(book_name)
	  readers = Hash.new(0)
	  lib.orders.each do |order|
		readers[order.reader] += 1 if order.book.name == book_name
	  end
	  readers.sort_by {|_key, value| value}.first
  end
  
  def most_popular_book
	  books = Hash.new(0)
	  lib.orders.each { |order| books[order.book] += 1 }
	  books.sort_by {|_key, value| value}.to_h.first
  end
  
  def people_count_of_top_three_books
	  books = Hash.new {|h,k| h[k] = Array.new }
	  lib.orders.each { |order| books[order.book] << order.reader }
	  popular = books.sort_by {|_key, value| value.size}[0..2].to_h
	  people_count = 0
	  popular.each_value {|v| people_count += v.uniq.size}
	  people_count
  end
  
  def save_to_file
    File.open("library.yaml", "a") {|f| f.puts YAML::dump(self)}
  end
  
  def self.get_from_file(path)
    array = []
	$/="\n\n"
	File.open(path, "r").each do |object|
		array << YAML::load(object)
	end
	array
  end
end

p Library.get_from_file("library.yaml")







