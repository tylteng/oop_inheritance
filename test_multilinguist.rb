require 'minitest/autorun'
require 'minitest/pride'
require './multilinguist.rb'

class TestMultilinguist < Minitest::Test

def test_language_in
  @multilinguist = Multilinguist.new

  language = @multilinguist.language_in('China')
  expected = 'zh'

  assert_equal(expected, language)
end

end
