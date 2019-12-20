% ============================= %
%    StudentName: Hui Chen	%
%    StudentNumber:180018809	%
% ============================= %

-module (task3).
-export ([load/1,count/3,go/1,join/2,split/2,countsplit/3]). 

%loading the file, such as "hamlet.txt" or "war.txt";
%the file should be in the same folder as the task3.erl codes;

%this part of codes modifies the 'ccharcount.erl' example,
%by adding the function spawning to distribute the task across processes,
%and a receiving function to collect all the results back from processes;

load(F)->
{ok, Bin} = file:read_file(F),
   List=binary_to_list(Bin),
   Length=round(length(List)/20),
   Ls=string:to_lower(List),
   Sl=split(Ls,Length),
   io:fwrite("Loaded and Split~n"),
   spawning(Sl, 1, self()),
   Result = receiving([], 0),
   io:fwrite("Result: ~p~n",[Result]).
 
%the function to add the results together from the indivdual processes.
%this is a similar idea as a reducer job in MapReduce;

add_result([], [], Z) -> Z;
add_result(H, [], []) -> H;
add_result([H|T], [X|Y], Z) ->
    Num = element(2, H),
    Num2 = element(2, X),
    A = setelement(2, X, Num+Num2),
    B = Z ++ [A],
    add_result(T, Y, B).

%the function to receive the results from each count process.
%using message passing technique;

receiving(R, 21) -> R;
receiving(R, C) ->
    receive 
      {Pid, Result} -> 
        T = add_result(Result, R, []),
        Pid ! stop
    end,
    receiving(T, C+1).

%the function to spawn to 21 processes.
%this is the starting point of making the job concurrent by distributing tasks to 21 processes;
%similar to a Mapper job of MapReduce;

spawning([H|T], N, Receiving) ->
    Pid = spawn(task3, countsplit, [H, [], Receiving]),
    io:fwrite("Starting Process #~p, with Process ID: ~p~n",[N, Pid]),
    spawning(T,N+1, Receiving);
spawning([], N, _) -> 
    io:fwrite("Spawning to ~p processes completed.~n",[N-1]).

%the function to split the number of each character in given segment.
%this part of codes modifies the 'ccharcount.erl' example,
%by adding the function receiving as another argument for countsplit;

countsplit([], R, _)->R;
countsplit(L, R, Receiving)->
    Result = go(L),
    R2=join(R, Result),
    Receiving ! {self(),R2}. 
 
%joining the results together,
%this part of codes imported from the 'ccharcount' example;

join([], [])->[];
join([], R)->R;
join([H1|T1], [H2|T2])->
    {_, N} = H1,
    {C1, N1} = H2,
    [{C1, N+N1}]++ join(T1, T2).

%Spliting the loaded file in segments
%this part of codes also imported from the 'ccharcount' example;

split([],_)->[];
split(List,Length)->
S1=string:substr(List,1,Length),
case length(List) > Length of
   true -> S2= string:substr(List, Length+1, length(List));
   false -> S2= []
end,
   [S1]++ split(S2, Length).

%Counting the number of characters in segment.
%this part of codes also imported from the 'ccharcount' example;

count(_, [],N)->N;
count(Ch, [H|T],N) ->
   case Ch==H of
   true-> count(Ch,T,N+1);
   false -> count(Ch,T,N)
end.

%collecting number of characters and format them in tuples.
%this part of codes also imported from the 'ccharcount' example;

go(L)->
Alph=[$a,$b,$c,$d,$e,$f,$g,$h,$i,$j,$k,$l,$m,$n,$o,$p,$q,$r,$s,$t,$u,$v,$w,$x,$y,$z],
rgo(Alph,L,[]).

rgo([],_,Result) -> Result;
rgo([H|T],L,Result)->
N=count(H,L,0),
Result2=Result++[{[H],N}],
rgo(T,L,Result2).
