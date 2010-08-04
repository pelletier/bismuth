{application, bismuth, [
	{description, "Bismuth"},
	{vsn, "0.1"},
	{modules, [bismuth_app]},
	{env, [
		{config_path, "./config.cfg"}
	]},
	{registred, [bismuth_app]},
	{applications, [kernel, stdlib]},
	{mod, {bismuth_app, []}}
]}.