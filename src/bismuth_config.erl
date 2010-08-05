-module(bismuth_config).
-include("bismuth.hrl").
-export([get/1, in_get/2]).


% Public %
get(Key) ->
	in_get(Key, grab_cfg()).

% Private %
grab_cfg() ->
	{ok, Configfilepath} = application:get_env(?APPNAME, config_path),
	Data = case file:consult(Configfilepath) of
		{ok, Val} ->
			Val;
		{error, enoent} ->
			io:format("The file at ~p does not exist or is not readable!~n", [Configfilepath]),
			[]
	end,
	Data.
		
in_get(_Key, []) ->
	{error, not_found};
in_get(Key, [{Key, Value} | _Config]) ->
	{ok, Value};
in_get(Key, [{_Other, _Value} | Config]) ->
	in_get(Key, Config).