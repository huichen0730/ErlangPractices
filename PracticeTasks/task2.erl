% ============================= %
%    StudentName: Hui Chen	%
%    StudentNumber:180018809	%
% ============================= %

-module(task2).
-export([find_unique/1]). %the basic task:reading from a list
-export([check_file/1]).  %extra bonus:reading from a file

%creating a list named L with value like [2,5,3,6,3,2,7,8,5,6] before calling the function;
%alternatively, just creating a list as the argument of function find_unique([])
%e.g task2:find_unique([2,5,3,6,2,7,8,5,6]).


%defining the format and layout of result output

find_unique(L) ->
	Result = be_unique(L), io:format("Unique Words:~p \n", [Result]), io:fwrite("Total Number of Unique Words:~p \n", [len(Result)]).


%removing repeated values from the L list to make items display as unique
%using heads and tails to check through the list with recursion;

be_unique([]) -> 
	[];
be_unique([H|T]) ->
	[H| [A || A <- be_unique(T), A /= H]].


%calculating the length of the L list to count how many unique words there are

len(L) -> 
	len(L,0).
len([], Count) -> 
	Count;
len([_|T], Count) -> 
	len(T, Count+1).


%checking unique values in the file and counting the num of unique words,
%the file name can be such as "hamlet.txt" which should be located in the same folder as task2.erl codes;
%loading file in first;

check_file(F) ->
	{ok, List} = file:read_file(F),
	L = binary_to_list(List),
	T = split_string(string:to_lower(L)),
	Result = find_unique(T),
	Result.


%splitting string based on the following separator lists such as symbols and numbers.

split_string(L) ->
	string:tokens(L," !@£$%^&*()-_+=[]{}:;?'/><.,\\\n\r\"0123456789").
	