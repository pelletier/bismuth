-module(bismuth_views).
-compile([export_all]).

queues(Req, Vhost, _RestOfPath) ->
	R = bismuth_rabbit:rpc_call(rabbit_amqqueue, info_all, [Vhost]),
	Result = bismuth_utils:normalize(R, [pid]),
	ResultAsDict = bismuth_utils:as_dict(Result, queue),
	DataOut = mochijson2:encode(ResultAsDict),
	bismuth_rest:ok(Req, DataOut).