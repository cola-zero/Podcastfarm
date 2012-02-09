require 'minitest/autorun'
require 'mocha'

path = File.expand_path "../../lib/podcastfarm", __FILE__
$:.push(path) unless $:.include?(path)

class MiniTest::Spec
  class << self
    alias :context :describe
  end
end
