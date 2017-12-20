require 'httparty'
require 'json'


# This class represents a world traveller who knows what languages are spoken in each country
# around the world and can cobble together a sentence in most of them (but not very well)
class Multilinguist

  TRANSLTR_BASE_URL = "http://bitmakertranslate.herokuapp.com"
  COUNTRIES_BASE_URL = "https://restcountries.eu/rest/v2/name"
  #{name}?fullText=true
  #?text=The%20total%20is%2020485&to=ja&from=en


  # Initializes the multilinguist's @current_lang to 'en'
  #
  # @return [Multilinguist] A new instance of Multilinguist
  def initialize
    @current_lang = 'en'
  end

  # Uses the RestCountries API to look up one of the languages
  # spoken in a given country
  #
  # @param country_name [String] The full name of a country
  # @return [String] A 2 letter iso639_1 language code

  def language_in(country_name)
    params = {query: {fullText: 'true'}}
    response = HTTParty.get("#{COUNTRIES_BASE_URL}/#{country_name}", params)
    json_response = JSON.parse(response.body)
    json_response.first['languages'].first['iso639_1']
  end

  # Sets @current_lang to one of the languages spoken
  # in a given country
  #
  # @param country_name [String] The full name of a country
  # @return [String] The new value of @current_lang as a 2 letter iso639_1 code
  def travel_to(country_name)
    local_lang = language_in(country_name)
    @current_lang = local_lang
  end

  # (Roughly) translates msg into @current_lang using the Transltr API
  #
  # @param msg [String] A message to be translated
  # @return [String] A rough translation of msg
  def say_in_local_language(msg)
    params = {query: {text: msg, to: @current_lang, from: 'en'}}
    response = HTTParty.get(TRANSLTR_BASE_URL, params)
    json_response = JSON.parse(response.body)
    json_response['translationText']
  end
end

class MathGenius < Multilinguist

  def sum(array)
    sum = 0
    array.each do |x|
      sum += x
    end
    puts "#{say_in_local_language("The total is")} #{sum}"
  end

end

class QuoteCollector < Multilinguist

  def initialize
    @quotes = []
  end

  def quotes
    @quotes
  end

  def add_quote(quote)
    @quotes << say_in_local_language(quote)
  end

  def random_quote
    counter = 0
    @quotes.each do |x|
      counter += 1
    end
    puts @quotes[rand(counter)]
  end

end

me = MathGenius.new
array = [10, 12, 40, 20, 300]

tyler = QuoteCollector.new
tyler.add_quote("Hello")
tyler.travel_to("India")
tyler.add_quote("Hey")
tyler.travel_to("Italy")
tyler.add_quote("Hi")
tyler.random_quote
# me.sum(array)
# me.travel_to("India")
# me.sum(array)
# me.travel_to("Italy")
# me.sum(array)
