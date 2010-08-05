# Compile & use

Edit config.cfg to fit your needs, then run!

    $ make start

You can also just compile:

    $ make bismuth

Then run:

    $ erl -pa ./ebin -pa ./deps/*/ebin -name bismuth -s bismuth_app boot -sname bismuth@yourhost -boot start_sasl

# URIs

The schema is simple:

    /<command>/[optional/args/]

So we have:

<dl>
    <dt>/queues/</dt>
    <dd>List the queues and provide their stats.</dd>
    <dt>/queues/queuename</dt>
    <dd>Retrieve the informations about the given queue.</dd>
</dl>

You can always provide the following `GET` parameters:

<dl>
    <dt>vhost</dt>
    <dd>The vhost you want to query. Default is `/`.</dd>
</dl>