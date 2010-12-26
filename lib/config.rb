module TotalProfiler
  class Config
    class << self
      attr_accessor :profile_all, :logger
      attr_reader :classes
      
      def add_class klass, methods=[]
        methods = [methods] unless methods.is_a? Array
        @classes ||= []
        @classes << {:class => klass, :methods => methods}
      end
    end
  end
end
