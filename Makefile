EMAKE = erl -make
ERL = erl

mochi:
	cd deps/mochiweb; $(MAKE)

json:
	cd deps/rfc4627; $(MAKE)

bismuth: mochi json
	$(EMAKE) Emakefile

all: bismuth

clean:
	rm -Rf ebin/*.beam

boot:
	cd ebin; $(ERL) -pa ./ebin/ -noshell -run make_boot write_scripts bismuth

start: bismuth
	$(ERL) -pa ./ebin -pa ./deps/*/ebin -name bismuth -s reloader -sname bismuth@MacBookPro-Thomas -boot start_sasl