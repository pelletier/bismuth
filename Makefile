EMAKE = erl -make
ERL = erl

mochi:
	cd deps/mochiweb; $(MAKE)

bismuth: mochi
	$(EMAKE) Emakefile

all: bismuth

boot:
	cd ebin; $(ERL) -pa ./ebin/ -noshell -run make_boot write_scripts bismuth

start: bismuth
	$(ERL) -pa ./ebin -pa ./deps/*/ebin -name bismuth -s reloader -sname bismuth@MacBookPro-Thomas