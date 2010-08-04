-module(bismuth_utils).
-export([normalize/1, normalize/2, contains/2]).

% Check if any key in the first list exists in the second one.
contains([], _List) ->
	false;
contains([Key|OtherKeys], List) ->
	case contains(Key, List) of
		true ->
			true;
		
		false ->
			contains(OtherKeys, List)
	end;
contains(_Key, []) ->
	false;
contains(Key, List) ->
	lists:any(fun(X) -> Key == X end, List).


% Create pairs of elements by grouping items of a list.
% [a, b, c, d, e, f] -> [{a, b}, {c, d}, {e, f}]
chunk([]) ->
	[];
chunk(List) ->
	[K, V | Tail] = List,
	lists:append([{K, V}], chunk(Tail)).


% Normalize a list of tuples to ensure each tuple is a pair.
% (Because Rabbit sends non JSONable responses).
normalize(L) ->
	normalize(L, [], []).
normalize(L, Blacklist) ->
	normalize(L, Blacklist, []).
normalize([], _Blacklist, Result) ->
	Result;
normalize([Head|Tail], Blacklist, Result) ->
	Changed = in_normalize(Head, Blacklist),
	io:format("____> ~p~n", [Changed]),
	normalize(Tail, Blacklist, [Changed|Result]).

in_normalize([], _Blacklist) ->
	[];
in_normalize(List, Blacklist) ->
	[Item|Tail] = List,
	Result = case Item of
		[A] ->
			in_normalize(A, Blacklist);
		{K, T} when is_atom(K) andalso is_tuple(T) ->
			L = tuple_to_list(T),
			chunk(L);
		{K, V} when is_atom(K) ->
			case contains([K], Blacklist) of
				true ->
					[];
				false ->
					[{K, V}]
			end;
		_ ->
			[]
	end,
	lists:append(Result, in_normalize(Tail, Blacklist)).