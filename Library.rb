require 'yaml'
require 'benchmark'
require_relative 'Author'
require_relative 'Book'
require_relative 'Reader'
require_relative 'Order'

# Library
class Library
  attr_accessor :books, :orders, :readers, :authors

  def initialize
    @books = []
    @orders = []
    @readers = []
    @authors = []
  end

  def fill_new_order
    reader = Reader.new('Name2', 'em2@ls.sa', 'City2', 'Street2', '2')
    author = Author.new('Aut1', 'Biogr1')
    book = Book.new('Title1', author)
    order = Order.new(book, reader, Time.now.to_date)

    @books << book
    @readers << reader
    @authors << author
    @orders << order
  end

  def often_reader(book_title)
    readers = @orders.select { |order| order.book.title == book_title }.map!(&:reader)
    readers.sort_by { |_key, value| value }.first
  end

  def most_popular_book
    books = Hash.new(0)
    orders.each { |order| books[order.book] += 1 }
    books.sort_by { |_key, value| value }.reverse[0][0].title
  end

  def readers_top_three_books
    books = Hash.new { |h, k| h[k] = [] }
    orders.each { |order| books[order.book] << order.reader }
    popular = books.sort_by { |_key, value| value.size }[0..2].to_h
    readers_count = 0
    popular.each_value { |v| readers_count += v.uniq.size }
    readers_count
  end

  def save_to_file(path)
    File.open(path, 'w') { |f| f.puts YAML.dump(self) }
  end

  def self.load_from_file(path)
    YAML.load(File.read(path))
  end
end

lib1 = Library.load_from_file('library.yaml')
p "Often reader of Title1: #{lib1.often_reader('Title1')}"
p "Most popular book: #{lib1.most_popular_book}"
p "Readers of top three books: #{lib1.readers_top_three_books}"
