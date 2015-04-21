comparing_pred(X):- X > 3.
negating_pred(X):- between(1,5,X), not(X > 3).
listing_pred(Xs):- findall(X, between(1,5,X), Xs).
complex_pred(_):- forall((between(1,5,X), A is X + 2), not(A = 2)).

:- begin_tests(expectations).

test(negating_pred_has_not, nondet):-
  hasNot(pred(negating_pred,1)).

test(negating_pred_doesn_use_findall, [fail]):-
  hasFindall(pred(negating_pred,1)).

test(negating_pred_doesn_use_forall, [fail]):-
  hasForall(pred(negating_pred,1)).

test(negating_pred_uses_greater, nondet):-
  usesPredicate(pred(negating_pred,1), pred((>),2)).

test(comparing_pred_uses_greater, nondet):-
  usesPredicate(pred(comparing_pred,1), pred((>),2)).

test(is_or_contains_is_recursive, nondet):-
  recursive(pred(isOrContains,2)).

test(listing_pred_uses_findall, nondet):-
  hasFindall(pred(listing_pred,1)).

test(complex_pred_uses_forall, nondet):-
  hasForall(pred(complex_pred,1)).

test(complex_pred_has_not, nondet):-
  hasNot(pred(complex_pred,1)).

test(complex_pred_uses_equals, nondet):-
  usesPredicate(pred(complex_pred,1), pred((=),2)).

:- end_tests(expectations).