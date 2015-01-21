@count = 0
current_valuation = []
Dashing.scheduler.every '10s' do
   @products = Product.all
   @products.each do |product|
     current_valuation << product.price
   end

   puts "#{current_valuation}"
   last_valuation = current_valuation[@count]

   Dashing.send_event('valuation', { current: current_valuation[@count], last: last_valuation })

    @count = (@count == current_valuation.size-1) ? 0 : (@count +1)

end



require 'open-uri'
Dashing.scheduler.every '5s', :first_in => 0 do |job|
  response = Nokogiri::HTML(open("https://news.google.com/"))
  news_headlines = []
  response.css('.esc').each do |news_item|
    news_headline = NewsHeadlineBuilder.BuildFrom(news_item)
    news_headlines.push(news_headline)
  end
  news_headlines
  Dashing.send_event('headlines', { :headlines => news_headlines})
end

class NewsHeadlineBuilder
  def self.BuildFrom(news_item)
    {
        title: news_item.css('span.titletext').text,
        description: news_item.css('div.esc-lead-snippet-wrapper').text,
    }
  end
end



