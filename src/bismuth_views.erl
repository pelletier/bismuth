-module(bismuth_views).
-compile([export_all]).

queues(Req, Vhost, RestOfPath) ->
	case RestOfPath of
		[] ->
			% No queue name given. Let's return them all.
			R = bismuth_rabbit:rpc_call(rabbit_amqqueue, info_all, [Vhost]),
			Result = bismuth_utils:normalize(R, [pid]),
			ResultAsDict = bismuth_utils:as_dict(Result, queue),
			DataOut = mochijson2:encode(ResultAsDict);
		
		[QueueName] ->
			% Given only informations for the queue
			R = bismuth_rabbit:rpc_call(rabbit_amqqueue, info_all, [Vhost]),
			Result = bismuth_utils:normalize(R, [pid]),
			ResultFiltered = bismuth_utils:filter_only(Result, queue, list_to_binary(QueueName)),
			DataOut = mochijson2:encode(ResultFiltered);
		
		_ ->
			% Raise an error
			DataOut = "badarg"
	end,
	
	bismuth_rest:ok(Req, DataOut).