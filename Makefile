F=

.PHONY: s
s:
	zig build run -freference-trace

.PHONY: t
t:
	TEST_FILTER='${F}' zig build test -freference-trace --summary all
