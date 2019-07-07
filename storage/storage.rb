require_relative 'my_hash'

class Storage
  attr_accessor :hash

  def initialize
    initial_file unless File.exist?('database')
    @hash = MyHash.new([])
    read_from_file
  end

  def read_from_file
    File.readlines('database').each do |line|
      attrs = line.split(' ')
      @hash[attrs[0].to_sym]= MyHash.new([[:quantity, attrs[1].to_i], [:price, attrs[2].to_i]])
    end
  end

  def save
    File.open('database', 'w+') do |f|
      @hash.each do |key, value|
        f.puts "#{key} #{value[:quantity]} #{value[:price]}\n"
      end
    end
  end

  def initial_file
    File.open('database', 'wb').close
  end

  def add(name, attributes)
    @hash[name]= attributes
    save
  end

  def delete(name)
    @hash.delete(name)
    save
  end

  def update(name, attribute)
    @hash[name]= attribute
    save
  end

  def total_storage_quantity
    @hash.map do |el|
      el[1][:quantity]
    end.inject(&:+)
  end

  def total_storage_price
    @hash.map do |el|
      total_price(el[0])
    end.inject(&:+)
  end

  def total_price(name)
    @hash[name][:quantity] * @hash[name][:price]
  end
end
