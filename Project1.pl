%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Shai Caspin CS3234 Project 1, Spring 2018 NUS
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This section declares prefix and infix notations                        %

% as well as precedence of connectives                                    %

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:-op(1200, xfy, implies).
:-op(600, xfy, and).
:-op(500, xfy, or).
:-op(500, xfy, xor).
:-op(100, fy, not).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% interpretation/2                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
interpretation(GFormula,TruthValue):- same(GFormula, TruthValue).

same(P, Q):- (nonvar(Q); Q=true; Q=false) ,(P and Q) or (not P and not Q).

top.
bot:-false.
implies(P,Q) :- P->Q.
and(P,Q) :- P,Q.
or(P,Q) :- (P;Q).
xor(P,Q) :- (P or Q), not(P and Q).

% interpretation(top and top, true). % should succeeds.
% interpretation(bot or bot, false). % should succeeds.
% interpretation(top xor top, true). % should fail.
% interpretation(top xor top, X). % should succed with X = false.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% propositions/2                                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

propositions(Sentence, L):- term_string(Sentence, String), split_string(String, " ()", " ", AllWords), no_connect(AllWords, Props), convert_to_atom(Props, [], Props2), sort(Props2, L).

no_connect(All, L):- subtract(All, ["and", "or", "xor", "not", ""], L).

convert_to_atom([],L, LFinal):- LFinal=L.
convert_to_atom([Head|Tail], AtomList, L):- atom_string(At,Head), append([At], AtomList, NewList), convert_to_atom(Tail, NewList,L).

% propositions(x1 xor x2, L). % should succeed with L = [x1, x2]. WORKS
% propositions(not x1 and  x1, L). % should succeed with L = [x1]. WORKS


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% assign/4                                                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

assign(Formula1, Proposition, TruthValue, Formula2):- term_string(Formula1, Formula1String), split_string(Formula1String, " ()", " ", FormulaList),term_string(Proposition, PropositionString), term_string(TruthValue, TruthString), replace_substring(FormulaList, PropositionString, TruthString, FinalString), atomics_to_string(FinalString," ", Fin), term_string(Formula2,Fin).

replace_substring(Original, ToReplace, ReplaceWith, Final):- (ReplaceWith="true", replace(Original, ToReplace,"top", Final)); ReplaceWith="false", replace(Original, ToReplace, "bot", Final).

replace([], _, _, []).
replace([ToReplace|Tail], ToReplace, ReplaceWith, [ReplaceWith|TailNew]):- replace(Tail, ToReplace, ReplaceWith, TailNew).
replace([Head|Tail], ToReplace, ReplaceWith, [Head|TailNew]):- Head\=ToReplace, replace(Tail, ToReplace, ReplaceWith, TailNew).

% KNOWN BUG: eliminates all parentheses, ok because is not evaluated- creates problems in part 4
% assign(x1 xor x2, x1, true, L).
% should succeed with F = top xor x2

% assign(x1 implies x1, x1, true, L).
% should succeed with F = top implies top


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% assignment/3                                                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Write your code here.

assignment(Formula, TruthValue, L):- propositions(Formula, Props), all_poss(Formula, Props, TruthValue, L).

all_poss(Formula, [], TruthValue , L):- L=[], interpretation(Formula, TruthValue), !.
all_poss(Formula, [Head|Tail], TruthValue, L):- assign(Formula, Head, true, End), append([[Head, true]], L1, L), all_poss(End, Tail, TruthValue, L1).
all_poss(Formula, [Head|Tail], TruthValue, L):- assign(Formula, Head, false, End), append([[Head, false]], L1, L), all_poss(End, Tail, TruthValue, L1).

% assignment(not (x1 and not x2 ), T, L).
% should succeeds 4 times with the corresponding truth values.

% ?- assignment(not (x1 and not x2), T, L).
% T = false
% L = [[x1, true], [x2, true]]
% Yes (0.00s cpu, solution 1, maybe more)
% T = false
% L = [[x1, true], [x2, false]]
% Yes (0.00s cpu, solution 2, maybe more)
% T = false
% L = [[x1, false], [x2, true]]
% Yes (0.00s cpu, solution 3, maybe more)
% T = true
% L = [[x1, false], [x2, false]]
% Yes (0.00s cpu, solution 4, maybe more)
% No (0.00s cpu)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Tests (add the tests that you are using)                                %

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% F = not y xor x and z, assignment(F, T, L)
% assignment( x3 and x4 and x5 and not(x6 or x1) , false, L).
% assignment(x3 and x4 and x5 and not (x6 or x1), false, L).
% L = [[x1, true], [x3, true], [x4, true], [x5, false], [x6, true]]
% Yes (0.00s cpu, solution 1, maybe more)
% L = [[x1, true], [x3, true], [x4, true], [x5, false], [x6, false]]
% Yes (0.00s cpu, solution 2, maybe more)
% L = [[x1, true], [x3, true], [x4, false], [x5, true], [x6, true]]
% Yes (0.00s cpu, solution 3, maybe more)
% L = [[x1, true], [x3, true], [x4, false], [x5, true], [x6, false]]
% Yes (0.00s cpu, solution 4, maybe more)
% L = [[x1, true], [x3, true], [x4, false], [x5, false], [x6, true]]
% Yes (0.00s cpu, solution 5, maybe more)
% L = [[x1, true], [x3, true], [x4, false], [x5, false], [x6, false]]
% Yes (0.00s cpu, solution 6, maybe more)
% L = [[x1, true], [x3, false], [x4, true], [x5, true], [x6, true]]
% Yes (0.00s cpu, solution 7, maybe more)
% L = [[x1, true], [x3, false], [x4, true], [x5, true], [x6, false]]
% Yes (0.00s cpu, solution 8, maybe more)
% L = [[x1, true], [x3, false], [x4, true], [x5, false], [x6, true]]
% Yes (0.00s cpu, solution 9, maybe more)
% L = [[x1, true], [x3, false], [x4, true], [x5, false], [x6, false]]
% Yes (0.00s cpu, solution 10, maybe more)
% L = [[x1, true], [x3, false], [x4, false], [x5, true], [x6, true]]
% Yes (0.00s cpu, solution 11, maybe more)
% L = [[x1, true], [x3, false], [x4, false], [x5, true], [x6, false]]
% Yes (0.00s cpu, solution 12, maybe more)
% L = [[x1, true], [x3, false], [x4, false], [x5, false], [x6, true]]
% Yes (0.00s cpu, solution 13, maybe more)
% L = [[x1, true], [x3, false], [x4, false], [x5, false], [x6, false]]
% Yes (0.00s cpu, solution 14, maybe more)
% L = [[x1, false], [x3, true], [x4, true], [x5, true], [x6, true]]
% Yes (0.00s cpu, solution 15, maybe more)
% L = [[x1, false], [x3, true], [x4, true], [x5, false], [x6, true]]
% Yes (0.00s cpu, solution 16, maybe more)
% L = [[x1, false], [x3, true], [x4, true], [x5, false], [x6, false]]
% Yes (0.00s cpu, solution 17, maybe more)
% L = [[x1, false], [x3, true], [x4, false], [x5, true], [x6, true]]
% Yes (0.00s cpu, solution 18, maybe more)
% L = [[x1, false], [x3, true], [x4, false], [x5, true], [x6, false]]
% Yes (0.01s cpu, solution 19, maybe more)
% L = [[x1, false], [x3, true], [x4, false], [x5, false], [x6, true]]
% Yes (0.01s cpu, solution 20, maybe more)
% L = [[x1, false], [x3, true], [x4, false], [x5, false], [x6, false]]
% Yes (0.01s cpu, solution 21, maybe more)
% L = [[x1, false], [x3, false], [x4, true], [x5, true], [x6, true]]
% Yes (0.01s cpu, solution 22, maybe more)
% L = [[x1, false], [x3, false], [x4, true], [x5, true], [x6, false]]
% Yes (0.01s cpu, solution 23, maybe more)
% L = [[x1, false], [x3, false], [x4, true], [x5, false], [x6, true]]
% Yes (0.01s cpu, solution 24, maybe more)
% L = [[x1, false], [x3, false], [x4, true], [x5, false], [x6, false]]
% Yes (0.01s cpu, solution 25, maybe more)
% L = [[x1, false], [x3, false], [x4, false], [x5, true], [x6, true]]
% Yes (0.01s cpu, solution 26, maybe more)
% L = [[x1, false], [x3, false], [x4, false], [x5, true], [x6, false]]
% Yes (0.01s cpu, solution 27, maybe more)
% L = [[x1, false], [x3, false], [x4, false], [x5, false], [x6, true]]
% Yes (0.01s cpu, solution 28, maybe more)
% L = [[x1, false], [x3, false], [x4, false], [x5, false], [x6, false]]
% Yes (0.01s cpu, solution 29, maybe more)
% No (0.01s cpu)

% ?- assignment(x3 and x4 and x5 and not (x6 or x1), true, L).
% L = [[x1, true], [x3, true], [x4, true], [x5, true], [x6, true]]
% Yes (0.00s cpu, solution 1, maybe more)
% L = [[x1, true], [x3, true], [x4, true], [x5, true], [x6, false]]
% Yes (0.00s cpu, solution 2, maybe more)
% L = [[x1, false], [x3, true], [x4, true], [x5, true], [x6, false]]
% Yes (0.00s cpu, solution 3, maybe more)
% No (0.00s cpu)
