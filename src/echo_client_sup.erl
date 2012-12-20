-module(echo_client_sup).

-export([start_link/0]).

-behaviour(supervisor2).

-export([init/1]).

start_link() ->
	supervisor2:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
    {ok, {{simple_one_for_one_terminate, 0, 1},
          [{echo_client, {echo_client, start_link, []}, 
				temporary, 10, worker, [echo_client]}]}}.


