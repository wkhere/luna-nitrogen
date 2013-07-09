%% -*- mode: nitrogen -*-
-module (index).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").

main() -> #template { file="./site/templates/bare.html" }.
debug_css() -> [].
title() -> "luna.inthephase".
desc() -> "All things lunar.".
keywords() -> "moon, moon phases, luna, lunar".

body() -> [
    #br{},
    #container_16 { body=[
        #grid_3 { prefix=2, alpha=true, body=logopix() },
        #grid_7 { suffix=4, omega=true, style="outline:1px dotted",
            body=logo()
        },
        #grid_clear{},
        #grid_16{}
    ]}
].

logopix() ->
    Pixtab = [
        "Golden_Moon", "Moonburn",
        "Lunar_eclipse_June_2011", "Solar_eclipse_1999"
    ],
    #image{
        image="/images/" ++ rand_element(Pixtab) ++ "_small.jpg",
        style="height:100px" }.

logo() -> [
    #p{},
    #span{ text="luna.inthephase",
        style="font-size:56px; font-family:Tahoma,Arial,sans-serif" },
    #p{}
].


%% helpers

rand_element(Xs) ->
    lists:nth( random:uniform(length(Xs)), Xs ).
