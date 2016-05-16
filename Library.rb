require 'yaml'
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
    readers = @orders.select { |order| order.book.title == book_title }
    readers.map!(&:reader).group_by(&:name).values.max_by(&:count).first.name
  end

  def most_popular_book
    @orders.group_by(&:book).values.max_by(&:count).first.book.title
  end

  def readers_top_three_books
    @orders.group_by(&:book).sort_by { |_k, v| v.size }.reverse[0..2]
      .to_h.values.flatten.uniq(&:reader).count
  end

  def save_to_file(path)
    File.open(path, 'w') { |f| f.puts YAML.dump(self) }
  end

  def self.load_from_file(path)
    YAML.load(File.read(path))
  end
end

lib1 = Library.load_from_file('library.yaml')
p "Often reader of Title1: #{lib1.often_reader('Title2')}"
p "Most popular book: #{lib1.most_popular_book}"
p "Readers of top three books: #{lib1.readers_top_three_books}"
