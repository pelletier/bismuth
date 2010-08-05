% Supervisor module for bismuth.
% This is a rough implementation of Erlang's Supervisor.

-module(bismuth_sup).
-include("bismuth.hrl").
-behavior(supervisor).
-export([start/2, init/1, stop/1]).


start(Type, Args)->
	supervisor:start_link(?MODULE, [Type, Args]).

init([_Type, Args]) ->
	RestServerSupervisor = {bismuth_rest_sup, {bismuth_rest_sup, start_link, [Args]}, permanent, 2000, worker, []},
	{ok, {_SupFlags = {one_for_one, ?MAXIMUM_RESTARTS, ?MAX_DELAY_TIME}, [RestServerSupervisor]}}.

stop(Args) ->
	bismuth_rest_sup:stop(Args),
	ok.