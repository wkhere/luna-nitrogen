-module(nitrogen_app).
-behaviour(application).
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    ok = mnesia_session_handler:install(),
    nitrogen_sup:start_link().

stop(_State) ->
    ok.
