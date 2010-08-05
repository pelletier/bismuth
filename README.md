# Compile & use

Edit config.cfg to fit your needs, then run!

    $ make start

You can also just compile:

    $ make bismuth

Then run:

    $ erl -pa ./ebin -pa ./deps/*/ebin -name bismuth -s bismuth_app boot -sname bismuth@yourhost -boot start_sasl
