% ttt starts a new game.  It obtains a new board, prints it, and then
%   accepts new moves until the game is over.  When this happens, it
%   prints a message and quits.  It can be invoke with or without
%   arguments.  The first argument is either 'Machine' or 'Human'
%   indicating who should go first.  The second argument is either
%   'X' or 'O' indicating whether the first player should use either
%   the 'X' or the 'O' symbol.  If ttt is invoked without arguments,
%   the human goes first using 'X'.
%
ttt :- ttt('Human', 'X').

ttt(Turn, Type) :-
    newboard(Board),
    printboard(Board),
    progress(Board, Turn, Type, _), !. % don't go on to the next game

% progress is responsible for playing a single game of tic tac toe.
%   It checks whether the game is over (first rule), and, if not (so execute the second rule), makes the next
%   move happen.  It then calls itself recursively.  If at any time,
%   it detects that the game is over (first rule), it prints a message and quits.

%   NOTE: in this case is fundamental the rule order!
%        (first is checked if the game is over and if not makes the next move)

progress(OldBoard, _, _, NewBoard) :-
    gameover(OldBoard), !,
    nl, print('Game is over.'), nl,
    NewBoard = OldBoard,
    printboard(NewBoard).

progress(OBoard, Turn, Type, NBoard) :-
    taketurn(OBoard, Turn, Type, Pos),
    setsquare(OBoard, Pos, Type, TBoard),
    printboard(TBoard),
    switch(Type, NType),
    switch(Turn, NTurn),
    progress(TBoard, NTurn, NType, NBoard).

% switch flips the state between Human and Machine and between X and O.
%
switch('X', 'O').
switch('O', 'X').
switch('Machine', 'Human').
switch('Human', 'Machine').

% taketurn makes the next move on the board.  It is known that when
%   the call is made, the game is not yet over.  If it is the human's
%   turn to move, getvalidmove is invoked to get the next valid move.
%   If it is the machine's turn to move, response is called to generate
%   the next square to occupy.
%
taketurn(Board, 'Human', _, Ans) :- getvalidmove(Ans, Board).

taketurn(Board, 'Machine', Type, Ans) :- 
    response(Board, Type, Ans),
    nl, print('Machine moving to square: '), print(Ans), nl.

% getvalidmove is a control structure that keeps asking for a valid
%   move until it gets one.  It uses checkmove to check for validity.
%
getvalidmove(Pos, Board) :-
    nl, print('Enter a board position as a number from 1 to 9: '),
    read(TPos),
    checkmove(TPos, Board, Pos).

% checkmove is a validity checker for moves.
%
checkmove(OPos, Board, NPos) :- 
    not(filledsquare(Board, OPos)),
    integer(OPos),
    OPos < 10,
    OPos > 0, !,
    NPos is OPos.

checkmove(_, Board, NPos) :-
    nl, print('Invalid move.  Try again.'), nl,
    printboard(Board),
    getvalidmove(NPos, Board).

% This file is the strategy module.  It is responsible for taking a
%   board and returning the best square into which to move. Currently
%   it uses the following strategies in order:
%
%   Try for a win, if one is possible.
%   Block the opponent, if necessary.
%   Take the center if possible.
%   Take the corners, in order, lowest numbered square first.
%   Take the sides, lowest numbered square first.
%
response(Board, Type, X) :-
    bestmove(Board, Type, X),
    not(filledsquare(Board, X)), !,
    print('response:bestmove='),print(X),nl.

bestmove(Board, Type, X) :- tryforwin(Board, Type, X), print('bestmove:tryforwin='),print(X),nl.
bestmove(Board, Type, X) :- block(Board, Type, X), print('bestmove:block='),print(X),nl.
bestmove(Board, _, X) :- trycenter(Board, X), print('bestmove:trycenter='),print(X),nl.
bestmove(Board, _, X) :- trycorner(Board, X), print('bestmove:trycorner='),print(X),nl.
bestmove(Board, _, X) :- tryedge(Board, X), print('bestmove:tryedge='),print(X),nl.

tryforwin(Board, Type, 1) :- foo(Board, Type, 1).
tryforwin(Board, Type, 2) :- foo(Board, Type, 2).
tryforwin(Board, Type, 3) :- foo(Board, Type, 3).
tryforwin(Board, Type, 4) :- foo(Board, Type, 4).
tryforwin(Board, Type, 5) :- foo(Board, Type, 5).
tryforwin(Board, Type, 6) :- foo(Board, Type, 6).
tryforwin(Board, Type, 7) :- foo(Board, Type, 7).
tryforwin(Board, Type, 8) :- foo(Board, Type, 8).
tryforwin(Board, Type, 9) :- foo(Board, Type, 9).

foo(Board, Type, X) :- 
%    not(filledsquare(Board, X)),
    setsquare(Board, X, Type, TBoard),
    threeinarow(TBoard).

block(Board, Type, 1) :- bar(Board, Type, 1).
block(Board, Type, 2) :- bar(Board, Type, 2).
block(Board, Type, 3) :- bar(Board, Type, 3).
block(Board, Type, 4) :- bar(Board, Type, 4).
block(Board, Type, 5) :- bar(Board, Type, 5).
block(Board, Type, 6) :- bar(Board, Type, 6).
block(Board, Type, 7) :- bar(Board, Type, 7).
block(Board, Type, 8) :- bar(Board, Type, 8).
block(Board, Type, 9) :- bar(Board, Type, 9).

bar(Board, Type, X) :- 
%    not(filledsquare(Board, X)),
    switch(Type, NType),
    setsquare(Board, X, NType, TBoard),
    threeinarow(TBoard).

trycenter(Board, 5) :- getsquare(Board, 5, '5').

trycorner(Board, 1) :- getsquare(Board, 1, '1').
trycorner(Board, 3) :- getsquare(Board, 3, '3').
trycorner(Board, 7) :- getsquare(Board, 7, '7').
trycorner(Board, 9) :- getsquare(Board, 9, '9').

tryedge(Board, 2) :- getsquare(Board, 2, '2').
tryedge(Board, 4) :- getsquare(Board, 4, '4').
tryedge(Board, 6) :- getsquare(Board, 6, '6').
tryedge(Board, 8) :- getsquare(Board, 8, '8').

% gameover is a predicate that succeeds if the game is over.  This happens
% if the board is filled or one of the players has three in a row.
%
gameover(Board) :- boardfilled(Board), !.
gameover(Board) :- threeinarow(Board).

% threeinarow matches if the board contains if either "X" or "O" has
%   three squares in a row.
%
threeinarow(Board) :- match(Board, [1, 2, 3]), !.
threeinarow(Board) :- match(Board, [4, 5, 6]), !.
threeinarow(Board) :- match(Board, [7, 8, 9]), !.
threeinarow(Board) :- match(Board, [1, 4, 7]), !.
threeinarow(Board) :- match(Board, [2, 5, 8]), !.
threeinarow(Board) :- match(Board, [3, 6, 9]), !.
threeinarow(Board) :- match(Board, [1, 5, 9]), !.
threeinarow(Board) :- match(Board, [3, 5, 7]).

% match succeeds if the argument squares all contain matching values.
%
match(Board, [S1, S2, S3]) :-
    getsquare(Board, S1, Value),
    getsquare(Board, S2, Value),
    getsquare(Board, S3, Value).

% boardfilled succeeds only if each of the squares on the board contains
% either an "X" or an "O".  It checks for this by looking at each square
% in turn.
%
boardfilled(Board) :- 
    filledsquare(Board, 1),
    filledsquare(Board, 2),
    filledsquare(Board, 3),
    filledsquare(Board, 4),
    filledsquare(Board, 5),
    filledsquare(Board, 6),
    filledsquare(Board, 7),
    filledsquare(Board, 8),
    filledsquare(Board, 9).

% filledsquare succeed if the indicated square in the board has an
%  "X" or an "O" already occupying it.
%
filledsquare(Board, Pos) :-
    getsquare(Board, Pos, Ans),
    goodtype(Ans).

% goodtype succeeds if its argument is "X" or "O".
%
goodtype('X').
goodtype('O').

% The valid externally callable functions are the following.
%    newboard - returns a new board.
%    getsquare - returns the contents of a square on the board.
%    setsquare - produces a new board, identical to the original except
%      that a single square has been altered.
%    printboard - displays the contents of a board.

% newboard returns a board suitable for starting a new game.
%
newboard([['1', '2', '3'], ['4', '5', '6'], ['7', '8', '9']]).

% getsquare returns the value of the square in the board indicated by Pos.
%
getsquare(Board, Pos, Ans) :- 
    convert(Pos, Lpos),
    tval(Board, Lpos, Ans).

% convert is responsible for converting from external notation (numbers
% from 0 to 9) to internal notation (row and column numbers).
%
convert(Pos, [Row, Col]) :-
    T1 is Pos - 1,
    Row is 1 + (T1 // 3),
    Col is 1 + (T1 mod 3).

tval([R1, R2, R3], [1, Col], Ans) :- getsq(R1, Col, Ans).
tval([R1, R2, R3], [2, Col], Ans) :- getsq(R2, Col, Ans).
tval([R1, R2, R3], [3, Col], Ans) :- getsq(R3, Col, Ans).

getsq([C1, C2, C3], 1, C1).
getsq([C1, C2, C3], 2, C2).
getsq([C1, C2, C3], 3, C3).

% printboard displays the contents of the board that is passed as its
%   argument.  It adds the grid and blank lines for cosmetic appeal.
%   It uses printrow to print the contents of the row.
%
printboard([X, Y, Z]) :-
    nl,
    printrow(X),
        print('     ---+---+---'), nl,
    printrow(Y),
        print('     ---+---+---'), nl,
    printrow(Z),
    nl.
    
printrow([P1, P2, P3]) :-
    print('      '),
    print(P1),
    print(' | '),
    print(P2),
    print(' | '),
    print(P3),
    print(' '),
    nl.

% setsquare returns a board altered by changing the value held in the square
%   indicated by Pos to the value indicated by Type.
%
setsquare(Board, Pos, Type, NewBoard) :-
    convert(Pos, Lpos),
    tpos(Board, Lpos, Type, NewBoard).

tpos([R1, R2, R3], [1, Col], Type, [Ans, R2, R3]) :- setsq(R1, Col, Type, Ans).
tpos([R1, R2, R3], [2, Col], Type, [R1, Ans, R3]) :- setsq(R2, Col, Type, Ans).
tpos([R1, R2, R3], [3, Col], Type, [R1, R2, Ans]) :- setsq(R3, Col, Type, Ans).

setsq([C1, C2, C3], 1, Type, [Type, C2, C3]).
setsq([C1, C2, C3], 2, Type, [C1, Type, C3]).
setsq([C1, C2, C3], 3, Type, [C1, C2, Type]). 