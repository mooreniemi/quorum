require 'minitest/autorun'
require 'minitest/reporters'
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
require 'pry'
require './app/app'

describe 'app' do
  before do
    @name = Name.new
    @hpoint = HashPoint.new
    @space = NameSpace.new(@name)
  end
  describe 'persisting' do
    it 'can access redis' do
      @space.attach(@hpoint)
      assert_includes @space.attached, @hpoint.id
    end
  end
  describe 'resolving' do
    it 'can get a name from a hashpoint' do
      Redis.current.setnx("_hpoint:#{@hpoint.id}", @name.id)
      assert_equal @name.id, Resolver.name_from(@hpoint)
    end
  end
end

describe Name do
  it 'sets id on initialization' do
    name = Name.new
    assert_kind_of String, name.id
  end
end
