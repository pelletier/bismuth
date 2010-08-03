{application, bismuth, [
	{description, "Bismuth"},
	{vsn, "0.1"},
	{modules, [bismuth_app]},
	{env, [
		{port, 4242},
		{log_path, "./bismuth.log"}
	]},
	{registred, [bismuth_app]},
	{applications, [kernel, stdlib]},
	{mod, {bismuth_app, []}}
]}.