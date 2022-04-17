module Loquat
  class ReservesToolTest < TestCase
    def setup
      @tool = Tool.create('reserves')
      @tool.keyword = 'プリキュア'
    end

    def test_uri
      assert_kind_of(Ginseng::URI, @tool.uri)
    end

    def test_fetch
      assert_kind_of(Array, @tool.fetch)
      @tool.fetch.first(5).each do |entry|
        assert_kind_of(Hash, entry)
      end
    end

    def test_entries
      assert_kind_of(Hash, @tool.entries)
    end

    def test_path
      assert_path_exist(@tool.path)
    end

    def test_help
      assert_kind_of(Array, @tool.help)
    end
  end
end
