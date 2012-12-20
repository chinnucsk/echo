-module(echo_app).

-export([start/0]).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

start() ->
	[application:start(App) || App <- [sasl, echo]].

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    {ok, Sup} = echo_sup:start_link(),
	echo_net:boot(),
	{ok, Sup}.

stop(_State) ->
    ok.

