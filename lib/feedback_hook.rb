class FeedbackHook < Mumukit::Hook
  def run_feedback!(request, results)
    build_feedback request, results, [
        :missing_predicate,
        :operator_error,
        :clauses_not_together,
        :singleton_variables,
        :wrong_distinct_operator,
        :wrong_comma,
        :not_sufficiently_instantiated,
        :test_failed]
  end

  def build_feedback(request, results, checks)
    content = request.content
    test_results = results.test_results[0]
    feedback = Feedback.new(content, test_results)
    checks.each { |it| feedback.check(it, &c(it)) }
    feedback.build
  end

  def c(selector)
    lambda { |content, test_results| self.send(selector, content, test_results) }
  end

  #FIXME may be extracted to mumukit
  class Feedback
    def initialize(content, test_results)
      @content = content
      @test_results = test_results
      @suggestions = []
    end

    def check(key, &block)
      binding = block.call(@content, @test_results)
      if binding
        @suggestions << I18n.t(key, binding)
      end
    end

    def build
      @suggestions.map { |it| "* #{it}" }.join("\n")
    end
  end

  def wrong_distinct_operator(content, _)
    (/.{0,9}(\/=|<>|!=).{0,9}/.match content).try do |it|
      {near: it[0]}
    end
  end

  def clauses_not_together(_, test_results)
    (/Clauses of .*:(.*) are not together in the source-file/.match test_results).try do |it|
      {target: it[1]}
    end
  end

  def singleton_variables(_, test_results)
    (/Singleton variables: \[(.*)\]/.match test_results).try do |it|
      {target: it[1]}
    end
  end

  def test_failed(_, test_results)
    /test (.*): failed/ =~ test_results
  end

  def not_sufficiently_instantiated(_, test_results)
    (/received error: (.*): Arguments are not sufficiently instantiated/.match test_results).try do |it|
      {target: it[1]}
    end
  end

  def operator_error(_, test_results)
    /ERROR: (.*): Syntax error: Operator expected/ =~ test_results
  end


  def wrong_comma(_, test_results)
    /ERROR: (.*): Full stop in clause-body\? Cannot redefine ,\/2/ =~ test_results
  end

  def missing_predicate(_, test_results)
    (/.*:(.*): Undefined procedure: .*:(.*)/.match test_results).try do |it|
      {target: it[1],
       missing: it[2]} unless it[1].include? 'unit body'
    end
  end

end
