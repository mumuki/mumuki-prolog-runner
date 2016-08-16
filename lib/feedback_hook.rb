class PrologFeedbackHook < Mumukit::Hook
  def run!(request, results)
    content = request.content
    test_results = results.test_results[0]

    PrologExplainer.new.explain(content, test_results)
  end

  class PrologExplainer < Mumukit::Explainer
    def explain_wrong_distinct_operator(content, _)
      (/.{0,9}(\/=|<>|!=).{0,9}/.match content).try do |it|
        {near: it[0]}
      end
    end

    def explain_wrong_gte_operator(content, _)
      (/.{0,9}(=>).{0,9}/.match content).try do |it|
        {near: it[0]}
      end
    end

    def explain_wrong_lte_operator(content, _)
      (/.{0,9}(<=).{0,9}/.match content).try do |it|
        {near: it[0]}
      end
    end


    def explain_clauses_not_together(_, test_results)
      (/Clauses of .*:(.*) are not together in the source-file/.match test_results).try do |it|
        {target: it[1]}
      end
    end

    def explain_singleton_variables(_, test_results)
      (/Singleton variables: \[(.*)\]/.match test_results).try do |it|
        {target: it[1]}
      end
    end

    def explain_test_failed(_, test_results)
      /test (.*): failed/ =~ test_results
    end

    def explain_not_sufficiently_instantiated(_, test_results)
      (/received error: (.*): Arguments are not sufficiently instantiated/.match test_results).try do |it|
        {target: it[1]}
      end
    end

    def explain_operator_error(_, test_results)
      /ERROR: (.*): Syntax error: Operator expected/ =~ test_results
    end

    def explain_missing_dot_error(_, test_results)
      /ERROR: (.*): Syntax error: Operator priority clash/ =~ test_results
    end


    def explain_wrong_comma(_, test_results)
      /ERROR: (.*): Full stop in clause-body\? Cannot redefine ,\/2/ =~ test_results
    end

    def explain_missing_predicate(_, test_results)
      (/.*:(.*): Undefined procedure: .*:(.*)/.match test_results).try do |it|
        {target: it[1],
         missing: it[2]} unless it[1].include? 'unit body'
      end
    end
  end
end
