all: sprite.msx

sprite.msx: sprite.bin
	z88dk-appmake +msx -b $< --org 40000 -o=$@

sprite.bin: sprite.asm
	z88dk-z80asm -b -o=$@ $<

.PHONY: clean test distclean

clean:
	rm -f *~ *.o *.bin *#

distclean: clean
	rm -Rf sprite.msx testdir

testdir:
	mkdir $@

testdir/sprite.msx: sprite.msx testdir
	cp $< $@

test: testdir/sprite.msx
	openmsx -machine msx2 -diska testdir -command 'after time 10 "type_from_file run"'


