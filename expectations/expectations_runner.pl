:- [expectations].

run_expectations(Expectations, Results) :-
  maplist(run_expectation, Expectations, Results).

run_expectation(Expectation, result(Expectation, Result)) :- eval_expectation(Expectation,Result).

eval_expectation(expectation(Binding, Inspection), true) :-
  call_expectation(Binding, Inspection), !.
eval_expectation(_, false).

call_expectation(Binding, inspection('HasBinding')) :-
  usesPredicate(pred(Binding, _), _).
call_expectation(Binding, inspection('HasForall')) :-
  hasForall(pred(Binding, _)).
call_expectation(Binding, inspection('HasFindall')) :-
  hasFindall(pred(Binding, _)).
call_expectation(Binding, inspection('HasNot')) :-
  hasNot(pred(Binding, _)).
call_expectation(Binding, inspection('HasUsage', Other)) :-
   usesPredicate(pred(Binding, _), pred(Other, _)).
call_expectation(Binding, inspection('HasDirectRecursion')) :-
   recursive(pred(Binding, _)).
call_expectation(Binding, inspection('HasArity', Arity)) :-
  usesPredicate(pred(Binding, Arity), _).
call_expectation(Binding, not(Inspection)) :-
   \+ call_expectation(Binding, Inspection).
call_expectation(Binding, inspection('HasCut')) :-
  hasCut(pred(Binding, _)).