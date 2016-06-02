class QueryHook < Mumukit::Templates::FileHook
  isolated true

  def command_line(filename)
    "#{swipl_path} -f #{filename} --quiet -t main 2>&1"
  end

  def compile_file_content(req)
    <<PROLOG
#{req.extra}
#{req.content}

main(_):-
  run_query('#{req.query.gsub('\\', '\\\\\\')}').

run_query(Query):-
    catch(findall(Result, (atom_to_term(Query, Term, Result), Term), ResultSet),
      error(TypeError,_),
      (handleQueryError(TypeError, Query), halt(100)) ),
    prettyWriteResultSet(ResultSet).

handleQueryError(type_error(callable,_), Query):-
  writef('ERROR: run_query/1: Expected Callable predicate but instead got %w\\n', [Query]).

handleQueryError(syntax_error(TypeSyntaxError), Query):-
  writef('ERROR: run_query/1: Syntax Error: %w in %w\\n', [TypeSyntaxError, Query]).

handleQueryError(signal(_,Number), _):-
  SignalStatus is 128 + Number,
  halt(SignalStatus).

handleQueryError(GeneralError, Query):-
  writef('ERROR: run_query/1: %w in \\'%w\\'\\n', [GeneralError, Query]).

prettyWriteResultSet([]):-
  writeln('no.').

prettyWriteResultSet([OneResult]):-
  prettyWriteOneResult(OneResult),
  writeln('.').

prettyWriteResultSet([OneResult | ResultSet]):-
  ResultSet \\= [],
  prettyWriteOneResult(OneResult),
  writeln(' ;'),
  prettyWriteResultSet(ResultSet).

prettyWriteOneResult([]):-
       write('yes').

prettyWriteOneResult([OneBinding]):-
       writeBinding(OneBinding).

prettyWriteOneResult([OneBinding | OneResult]):-
       OneResult \\= [],
       writeBinding(OneBinding),
       writeln(','),
       prettyWriteOneResult(OneResult).

writeBinding(OneBinding):-
       OneBinding=..[(=), VarName, Value],
       writef('%w = %w', [VarName, Value]).

writeBinding(NotABinding):-
       not(NotABinding=..[(=) | _ ]),
       writef('ERROR: writeBinding/1: Expected Binding, but no equals was found in: %w\\n', [NotABinding]),
       halt(101).

PROLOG
  end

end







