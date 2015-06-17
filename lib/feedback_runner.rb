require 'mumukit'

class FeedbackRunner < Mumukit::Stub
  def run_feedback!(request, results)
    suggestions = []
    content = request.content
    test_results = results.test_results

    suggestions << I18n.t(:wrong_distinct_operator) if wrong_distinct_operator(content)
    suggestions << I18n.t(:clauses_not_together) if clauses_not_together(test_results)
    suggestions << I18n.t(:singleton_variables) if singleton_variables(test_results)
    suggestions << I18n.t(:wrong_parameter_order) if test_failed(test_results)
    suggestions << I18n.t(:operator_error) if operator_error(test_results)
    suggestions << I18n.t(:wrong_comma) if cannot_redefine_comma(test_results)
    suggestions << t(:missing_predicate) if missing_predicate(test_results)
    suggestions.join("\n")
  end

  private

  def wrong_distinct_operator(content)
    %w(/= <> !=).any? { |it| content.include? it }
  end

  def clauses_not_together(test_results)
    /Clauses of plunit_mumuki_submission_test:(.*) are not together in the source-file/ =~ test_results
  end


  def singleton_variables(test_results)
    /Warning: (.*): Singleton variables: [(.*)]/ =~ test_results
  end

  def test_failed(test_results)
    /ERROR: (.*): test (.*): failed/  =~ test_results
  end

  def operator_error(test_results)
    /ERROR: (.*): Syntax error: Operator expected/  =~ test_results
  end


  def cannot_redefine_comma(test_results)
    /ERROR: (.*): Full stop in clause-body\? Cannot redefine ,\/2/  =~ test_results
  end

  def missing_predicate(test_results)
    /.*:(.*): Undefined procedure: .*:(.*)/ =~ test_results
  end

end
