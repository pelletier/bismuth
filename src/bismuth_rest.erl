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
%		  /queues/ -> List the queues and give their details.

start_link(Args) ->
	gen_server:start_link({local, ?SERVER}, ?MODULE, [Args], []).

init(_Args) ->
	io:format("Starting mochiweb...~n"),
	{ok, Port} = bismuth_config:get(port),
	mochiweb_http:start([{loop, fun loop/1}, {port, Port}]),
	io:format("HTTP server initalized.~n"),
	{ok, #state{}}.

% Dispatching HTTP requests
loop(Req) ->
	Path = Req:get(path),
	QueryString = Req:parse_qs(),
	Vhost = case bismuth_config:in_get("vhost", QueryString) of
		{ok, V} ->
			V;
		{error, _Blah} ->
			?DEFAULT_VHOST
	end,
	Tokens = string:tokens(Path, "/"),
	Command = Tokens,
	io:format("VHost: ~p~n", [Vhost]),
	case Tokens of
		[ViewName | RestOfPath] ->
			io:format("Call: ~p // ~p~n", [ViewName, RestOfPath]),
			apply(bismuth_views, list_to_atom(ViewName), [Req, Vhost, RestOfPath]);
		_ ->
			ok(Req, "This is actually a 404 message.")
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
	io:format("Code changed, oh yeah!"),
	{ok, State}.