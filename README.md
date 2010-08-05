# Compile & use

 1. Edit config.cfg to fit your needs.
 2. Run!

    $ make start

You can also just compile:

    $ make bismuth

Then run:

    $ erl -pa ./ebin -pa ./deps/*/ebin -name bismuth -s bismuth_app boot -sname bismuth@yourhost -boot start_sasl
