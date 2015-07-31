require 'minitest/autorun'
require 'redis-objects'
require './app/app'

describe 'app' do
  before do
    @name = Name.new
    @hpoint = HashPoint.new
    @space = NameSpace.new(@name)
  end
  describe 'basic' do
    it 'can access redis' do
      @space.attach(@hpoint)
      assert_includes @space.attached, @hpoint.id
    end
  end
end
