module Loquat
  class RecordingToolTest < TestCase
    def setup
      @tool = Tool.create('recording')
    end

    def test_uri
      assert_kind_of(Ginseng::URI, @tool.uri)
    end

    def test_fetch
      assert_kind_of(Array, @tool.fetch)
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
