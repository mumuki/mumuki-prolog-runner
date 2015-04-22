:- [expectations].

run_expectations(Expectations, Results) :-
  maplist(run_expectation, Expectations, Results).

run_expectation(Expectation, result(Expectation, Result)) :- eval_expectation(Expectation,Result).

eval_expectation(expectation(Binding, Inspection), true) :-
  call_expectation(Binding, Inspection), !.
eval_expectation(_, false).

call_expectation(Binding, inspection('HasBinding')) :-
  usesPredicate(Binding, _).
call_expectation(Binding, inspection('HasForall')) :-
  hasForall(Binding).
call_expectation(Binding, inspection('HasFindall')) :-
  hasFindall(Binding).
call_expectation(Binding, inspection('HasNot')) :-
  hasNot(Binding).
call_expectation(Binding, inspection('HasUsage', Other)) :-
   usesPredicate(Binding, Other).
call_expectation(Binding, inspection('HasArity', Arity)) :-
   hasArity(Binding, Arity).
call_expectation(Binding, not(Inspection)) :-
   \+ call_expectation(Binding, Inspection).
