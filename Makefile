all: compile

compile: deps
	rebar compile

deps: 
	rebar get-deps 

