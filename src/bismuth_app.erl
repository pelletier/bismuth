% Entry point for bismuth.
% It creates an Erlang Application.

-module(bismuth_app).
-behavior(application).
-export([start/2, stop/1, boot/0]).

boot() ->
	application:start(bismuth).

% Just call the supervsior and start a new bismuth instance.
start(Type, Args) ->
	io:format("Bismuth is starting.~n"),
	bismuth_sup:start(Type, Args).

% Ask the supervisor to stop its business.
stop(State) ->
	bismuth_sup:stop(State).