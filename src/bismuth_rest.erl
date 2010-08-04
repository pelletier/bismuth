-module(bismuth_rest).
-behavior(gen_server).
-include("bismuth.hrl").
-export([start_link/1, ok/2]).
-export([code_change/3, handle_call/3, handle_cast/2, handle_info/2, init/1, terminate/2]).
-record(state, {}).
-define(SERVER, ?MODULE). % For coherence.
-define(LOOP, {?MODULE, loop}).
-define(DEFAULT_VHOST, <<"/">>).


%
% URI
% /[vhost]/
%

start_link(Args) ->
	io:format("Rest server start_linkd~n"),
	gen_server:start_link({local, ?SERVER}, ?MODULE, [Args], []).

init(_Args) ->
	io:format("Starting mochiweb...~n"),
	{ok, Port} = bismuth_config:get(port),
	mochiweb_http:start([{loop, fun loop/1}, {port, Port}]),
	io:format("Rest server initalized.~n"),
	{ok, #state{}}.

% Dispatching HTTP requests
loop(Req) ->
	Path = Req:get(path),
	Tokens = string:tokens(Path, "/"),
	io:format("restarting loop normally in ~p~n", [Path]),
	Size = length(Tokens),
	io:format("size = ~p~n", [Size]),
	if
		Size>1 ->
			% A vhost name has been provided
			io:format("> 1~n"),
			[<<Vhost>>|Command] = Tokens;
		true ->
			io:format("1~n"),
			% Use the default instead
			Vhost = ?DEFAULT_VHOST,
			Command = Tokens
	end,
	io:format("Endif~n"),
	
	case Tokens of
		[ViewName | RestOfPath] ->
			apply(bismuth_views, list_to_atom(ViewName), [Req, Vhost, RestOfPath]);
		_ ->
			ok(Req, "other")
	end,
	ok.

% This is how we return HTTP Response
ok(Req, Response) ->
	Req:ok({_ContentType = "application/json", _Headers = [], Response}).

ok(Req, Response, Ctype) ->
	Req:ok({_ContentType = Ctype, _Headers = [], Response}).

%==================================================================================================%
% Rest of the gen_server implementation                                                            %
%==================================================================================================%

handle_call(_Request, _From, State) ->
	Reply = ok,
	{reply, Reply, State}.

handle_cast(_Msg, State) ->
	{noreply, State}.

handle_info(_Info, State) ->
	{noreply, State}.

terminate(_Reason, _State) ->
	mochiweb_http:stop(),
	ok.

code_change(_OldVsn, State, _Extra) ->
	{ok, State}.