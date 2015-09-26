
main(Query,Filename):-
	consult(Filename),
	run_query(Query).

run_query(Query):-
	findall(Result, (atom_to_term(Query, Term, Result), Term), ResultSet),
	prettyWriteResultSet(ResultSet).

prettyWriteResultSet([]):-
	writeln('false.').

prettyWriteResultSet([OneResult]):-
	prettyWriteOneResult(OneResult),
	writeln('.').

prettyWriteResultSet([OneResult | ResultSet]):-
	prettyWriteOneResult(OneResult),
	writeln(' ;'),
	prettyWriteResultSet(ResultSet).


prettyWriteOneResult([]):-
	write('true').

prettyWriteOneResult([OneBinding]):-
	writeBinding(OneBinding).

prettyWriteOneResult([OneBinding | OneResult]):-
	writeBinding(OneBinding),
	writeln(','),
	prettyWriteOneResult(OneResult).

writeBinding(OneBinding):-
	compound_name_arguments(OneBinding, (=), [VarName, Value]),
	writef('%w = %w', [VarName, Value]).

writeBinding(NotABinding):-
	writef('ERROR: writeBinding/1: Expected Binding, but no equals was founded in: %w\n', [NotABinding]),
	halt.