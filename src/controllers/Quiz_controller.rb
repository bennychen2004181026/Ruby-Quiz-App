class OpeningOptions
    def initialize(quiz_history,quiz_custom,quiz_test,quiz_view)
        @quiz_history=quiz_history
        @quiz_custom=quiz_custom
        @quiz_test=quiz_test
        @quiz_view=quiz_view
    end
    def run
          @quiz_view.interface
    end
    
    def add_custom
        @quiz_view.add_collection
  end
  
  def run_test
    @quiz_view.get_user_selection
end

def display_custom
    @quiz_view.select_collection
end

def records
    @quiz_view.history_select
end


end