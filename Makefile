EMAKE = erl -make
ERL = erl

mochi:
	cd deps/mochiweb; $(MAKE)

bismuth: mochi
	$(EMAKE) Emakefile

all: bismuth

clean:
	rm -Rf ebin/*.beam

boot:
	cd ebin; $(ERL) -pa ./ebin/ -noshell -run make_boot write_scripts bismuth

start: bismuth
	$(ERL) -pa ./ebin -pa ./deps/*/ebin -name bismuth -s bismuth_app boot -sname bismuth@MacBookPro-Thomas -boot start_sasl

silent: bismuth
	$(ERL) -pa ./ebin -pa ./deps/*/ebin -name bismuth -s bismuth_app boot -sname bismuth@MacBookPro-Thomas -boot start_sasl -detached