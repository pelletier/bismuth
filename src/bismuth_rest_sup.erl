-module(bismuth_rest_sup).
-behavior(supervisor).
-export([start_link/1, init/1, stop/1]).

start_link(Args) ->
	io:format("Starting rest server supervisor.~n"),
	supervisor:start_link({local, ?MODULE}, ?MODULE, Args).

init(Args) ->
	io:format("Rest server supervisor initd.~n"),
	{ok, {{one_for_one, 2, 10}, [{rest_server, {bismuth_rest, start_link, [Args]}, permanent, 2000, worker, [bismuth_rest]}]}}.

stop(_Args) ->
	Pid = whereis(?MODULE),
	exit(Pid, kill).