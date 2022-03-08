nokogiri = Nokogiri.HTML(content)

#initialize an empty hash
product = {}

#save the url
product['url'] = page['vars']['url']

#save the category
product['category'] = page['vars']['category']

#extract the asin
product['asin'] = page['url'].split('/').last

#extract title
product['title'] = nokogiri.at_css('#productTitle').text.strip

#extract seller/author
seller_node = nokogiri.at_css('a#bylineInfo')
if seller_node
  product['seller'] = seller_node.text.strip
end

#extract number of reviews
reviews_node = nokogiri.at_css('#acrCustomerReviewText')
reviews_count = reviews_node ? reviews_node.text.strip.split(' ').first.gsub(',','') : nil
product['reviews_count'] = reviews_count =~ /^[0-9]*$/ ? reviews_count.to_i : 0

#extract_rating
rating_node = nokogiri.at_css('i.a-icon-star.a-star-4-5 > span.a-icon-alt')
stars_num = rating_node ? rating_node.text.strip.split(' ').first : nil
product['rating'] = stars_num =~ /^[0-9.]*$/ ? stars_num.to_f : nil

#extract price
price_node = nokogiri.at_css('span.a-offscreen')
if price_node
    product['price'] = price_node.text.strip.gsub(/[\$,]/,'').to_f
end

#extract availability
availability_node = nokogiri.css('#availability span.a-size-medium')
if availability_node
  product['available'] = availability_node.text.strip == 'In Stock.' ? true : false
else
  product['available'] = nil
end

#extract product description
description = ''
nokogiri.css('#feature-bullets li').each do |li|
  unless li['id'] || (li['class'] && li['class'] != 'showHiddenFeatureBullets')
    description += li.text.strip + ' '
  end
end
product['description'] = description.strip

# specify the collection where this record will be stored
product['_collection'] = "products"

p product

# save the product to the job’s outputs
outputs << product