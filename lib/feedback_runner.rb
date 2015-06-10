require 'mumukit'

class FeedbackRunner < Mumukit::Stub
  def run_feedback!(request, results)
    suggestions = []
    content = request.content
    test_results = results.test_results

    suggestions << 'Recordá que el predicado infijo distinto en prolog se escribe así: \=' if wrong_neq_operator(content)
    suggestions << 'Recordá que es una buena práctica escribir toda las cláusulas de un mismo predicado juntas' if clauses_not_together(test_results)
    suggestions << 'Tenés variables sin usar' if singleton_variables(test_results)
    suggestions << 'Revisá si respetaste el orden de los parámetros en los predicados solicitados' if test_failed(test_results)
    suggestions << 'Cuidado, tenés errores de sintaxis. Revisá que el código esté bien escrito' if operator_error(test_results)
    suggestions << 'Cuidado, tenes errores de sintaxis. Puede ser que te esté faltando algún :- o que lo hayas confundido con una coma?' if cannot_redefine_comma(test_results)

    suggestions.join("\n")
  end

  private

  def wrong_neq_operator(content)
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

end
