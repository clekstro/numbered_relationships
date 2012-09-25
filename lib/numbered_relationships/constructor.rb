module NumberedRelationships
  class Constructor
    def initialize(options={})
      @n = options[:n]
      @operator = options[:operator]
      @filters = options[:filters]
      @klass = options[:klass]
      @reflection = options[:reflection]
    end

    def construct
      return @klass.scoped unless @reflection
    end

    private 

    def table
      @klass.name.tableize
    end

    def foreign_key
      @reflection.foreign_key
    end

    def association
      @reflection.name
    end

    def join_table
      @klass.reflect_on_association(association.to_sym).options[:join_table]
    end
    
    def through_model
      @reflection.options[:through]
    end

    def constantize_klass
      association.to_s.classify.constantize
    end
    
    def chain_symbols(symbols)
      symbols.map{ |s| s.to_s }.join('.')
    end
  end
end