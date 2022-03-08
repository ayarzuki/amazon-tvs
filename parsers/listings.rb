nokogiri = Nokogiri.HTML(content)

# puts nokogiri

products = nokogiri.css('.s-card-container', '.a-spacing-none.a-color-base')
    url_element = products.at_css('h2.s-line-clamp-2 > .a-link-normal.s-link-style.a-text-normal')
    re_url = url_element['href'].gsub(/&qid=[0-9]*/,'')
    url = "https://www.amazon.com#{re_url}"

    pages << {
        url: url,
        page_type: "products",
        method: "GET",
        headers: {"User-Agent" => "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36"},
        vars: { 
            category: page['vars']['category'],
            url: url    
        }
    }