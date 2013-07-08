require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products

  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end

  test "product price must be positive" do
    product = Product.new(title:       "My Book Title",
                          description: "This is a cool new book I wrote",
                          image_url:   "someimage.jpg")
    product.price = -1
    assert product.invalid?
    assert_equal [I18n.translate('errors.messages.greater_than_or_equal_to', count: 0.01)], product.errors[:price]

    product.price = 0
    assert product.invalid?
    assert_equal [I18n.translate('errors.messages.greater_than_or_equal_to', count: 0.01)], product.errors[:price]

    product.price = 1
    assert product.valid?, "price #{product.price} should not be valid"
  end

  def new_product(image_url)
    Product.new(title:       "My Book Title",
                description: "This is a cool new book I wrote",
                price:       10,
                image_url:   image_url)
  end

  test "image url" do
    ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg http://a.b.c./x/y/z/fred.gif }
    bad = %w{ fred.doc fred.gif/more fred.gif.more}

    ok.each do |name|
      product =  new_product(name)
      assert product.valid?, "#{name} should not be invalid"
    end

    bad.each do |name|
      product = new_product(name)
      assert product.invalid?, "#{name} should not be valid"
      assert_equal [I18n.translate('errors.messages.must_be_url_for_gif_or_jpg_or_png')], product.errors[:image_url]
    end
  end

  test "product title must be unique - i18n" do
    product = Product.new(title:        products(:ruby).title,
                          description:  "Another book with same title",
                          image_url:    "someimage.png",
                          price:        10)
    assert product.invalid?, "product #{product.title} is a duplicate and should not be allowed"
    assert_equal [I18n.translate('errors.messages.taken')], product.errors[:title]
  end
end
