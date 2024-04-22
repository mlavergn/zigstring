###############################################
#
# Makefile
#
###############################################

.DEFAULT_GOAL := build

###############################################

st:
	open -a SourceTree .

open:
	code .

setup:
	zig init-lib

build:
	zig build

clean:
	rm -rf zig-cache zig-build

format:
	zig fmt *.zig

release:
	zig build -Doptimize=ReleaseFast

run:
	zig run string.zig

test:
	zig test string.zig 
	zig test date.zig
