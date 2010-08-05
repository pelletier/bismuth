-module(bismuth_utils).
-export([normalize/1, normalize/2, contains/2, as_dict/2, filter_only/3]).


% Returns only the elements of the lists which contains a pair (Key, Value).
filter_only(List, Key, Value) ->
	io:format("Hello~n"),
	case in_filter(List, Key, Value, []) of
		[] ->
			io:format("Nothing found~n"),
			{error, not_found};
		[OneResult] ->
			io:format("One Result~n"),
			OneResult;
		ResultsList when is_list(ResultsList) ->
			io:format("Multiple Results~n"),
			ResultsList;
		_ ->
			{error, internal_problem}
	end.
in_filter([], _Key, _Value, Results) ->
	Results;
in_filter([Item|Tail], Key, Value, Results) ->
	io:format("Value; ~p~n", [Value]),
	io:format("Item: ~p~n", [Item]),
	case bismuth_config:in_get(Key, Item) of
		{ok, Value} ->
			io:format("before append~n"),
			Results2 = lists:append(Results, Item),
			io:format("Sounds good~n");
		_ ->
			Results2 = Results
	end,
	in_filter(Tail, Key, Value, Results2).
 

% Index a list of list of pairs (key, value) on the given key.
as_dict([], _Key) ->
	[];
as_dict([Item|List], Key)->
 	{ok, Value} = bismuth_config:in_get(Key, Item),
	io:format("VALUE ~p~n", [Value]),
	lists:append([{list_to_atom(binary_to_list(Value)), Item}], as_dict(List, Key)).
	

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
	io:format("NORMALIZE: ~p~n", [L]),
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