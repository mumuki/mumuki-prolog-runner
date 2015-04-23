:- [expectations_runner].

main(_) :-
  read(Filename),
  read(Expectations),
  consult('expectations/expectations.pl'),
  consult(Filename),
  run_expectations(Expectations, Results),
  write_json(Results).

write_json(Results) :-
  write('{"expectationResults":['),
  write_results(Results),
  write(']}').

write_results([]).
write_results([X1]) :-
  write_result(X1).
write_results([X1,X2|Xs]) :-
  write_result(X1),
  write(','),
  write_results([X2|Xs]).

write_result(result(expectation(Binding, Inspection), Result)) :-
  swrite_inspection(Inspection, SInspection),
  writef('{"expectation":{"binding":"%w", "inspection":"%w"},"result":%w}',
    [Binding, SInspection, Result]).

swrite_inspection(inspection(X), S) :-
  swritef(S, "%w", [X]).
swrite_inspection(inspection(X, Y), S) :-
  swritef(S, "%w:%w", [X, Y]).
swrite_inspection(not(Inspection), S2) :-
  swrite_inspection(Inspection, S1),
  swritef(S2, "Not:%w", [S1]).

