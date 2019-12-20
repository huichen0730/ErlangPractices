% ============================= %
%    StudentName: Hui Chen	%
%    StudentNumber:180018809	%
% ============================= %

-module(task1).
-export([calculate_Pi/0]).

%defining the result and setting the format of result output with 5 decimal points

calculate_Pi() ->
	Result = 4 * calculate_Pi(0,1,1),
	io:fwrite("Value of Pi: ~.5f \n", [Result]).
    
%recursion with pattern matching    
%R stands for Result.
%N stands for Numerator
%D stands for Denominator
%adding a condition to guide the program to know when to stop,
%if 1/D is smaller than 0.0000025, then there is no point to keep doing any more recursions as it would not make any more change on the result;

calculate_Pi(R, N, D) ->
	if
	   1/D > 0.0000025 -> calculate_Pi (R+(N*1/D),N*-1, D+2);
	   true -> R
	end.
