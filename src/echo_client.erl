-module(echo_client).

-export([start_link/1]).

-behaviour(gen_server).

-export([init/1,
		handle_call/3,
		handle_cast/2,
		handle_info/2,
		terminate/2,
		code_change/3]).

-record(state, {sock}).

start_link(Sock) ->
	gen_server:start_link(?MODULE, [Sock], []).

init([Sock]) ->
	inet:setopts(Sock, [{active, true}]),
	{ok, Peer} = inet:peername(Sock),
	error_logger:info_msg("peer: ~p~n", [Peer]),
	{ok, #state{sock=Sock}}.

handle_call(Req, _From, State) ->
	{stop, {badreq, Req}, State}.

handle_cast(Msg, State) ->
	{stop, {badmsg, Msg}, State}.

handle_info({tcp, Sock, Data}, State) ->
	ok = gen_tcp:send(Sock, Data),
	{noreply, State};

handle_info({tcp_closed, Sock}, #state{sock=Sock}=State) ->
	{stop, normal, State};

handle_info(Info, State) ->
	error_logger:info_msg("~p", [Info]),
	{noreply, State};

handle_info(Info, State) ->
	{stop, {badinfo, Info}, State}.

terminate(_Reason, _State) ->
	ok.

code_change(_, _, _) ->
	ok.



