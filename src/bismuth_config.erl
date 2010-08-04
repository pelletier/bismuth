-module(bismuth_config).
-include("bismuth.hrl").
-export([get/1]).


% Public %
get(Key) ->
	in_get(Key, grab_cfg()).

% Private %
grab_cfg() ->
	io:format("Grab CFG~n"),
	{ok, Configfilepath} = application:get_env(?APPNAME, config_path),
	io:format("End get env: ~p~n", [Configfilepath]),
	Data = case file:consult(Configfilepath) of
		{ok, Val} ->
			Val;
		{error, enoent} ->
			io:format("The file at ~p does not exist or is not readable!~n", [Configfilepath]),
			[]
	end,
	io:format("End consult: ~p~n", [Data]),
	Data.
		
in_get(_Key, []) ->
	{error, not_found};
in_get(Key, [{Key, Value} | _Config]) ->
	{ok, Value};
in_get(Key, [{_Other, _Value} | Config]) ->
	in_get(Key, Config).