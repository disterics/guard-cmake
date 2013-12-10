module Guard
  class CMake
    class Command < String

      attr_reader :title

      def initialize(title, command)
        super(command)
        @title = title
      end

    end
  end
end
