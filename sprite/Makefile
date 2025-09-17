all: sprite.bin

sprite.bin: sprite.asm
	z88dk-z80asm -l -b -o=$@ $<

#sprite.bin: sprite.asm
#	sjasmplus --raw=$@ --lst $<

.PHONY: clean test distclean

clean:
	rm -f *~ *# *.o *.lis *.lst

distclean: clean
	rm -Rf sprite.bin testdir

testdir:
	mkdir $@

testdir/sprite.bin: sprite.bin testdir
	cp $< $@

test: testdir/sprite.bin
	openmsx -machine msx2 -diska testdir -command 'after time 10 "type_from_file run"'

