-module(bismuth_rabbit).
-include("bismuth.hrl").
-export([rpc_call/3]).


rpc_call(Mod, Fun, Args) -> rpc:call(rabbit_node(), Mod, Fun, Args, ?RPC_TIMEOUT).


% Grab the rabbit node name from the configuration file
rabbit_node() ->
	io:format("get the config info~n"),
	{ok, Hostname} = bismuth_config:get(rabbitnode),
	io:format("config ok~n"),
	case Hostname of
		H when is_atom(H) -> H;
		Else -> list_to_atom(Else)
	end.