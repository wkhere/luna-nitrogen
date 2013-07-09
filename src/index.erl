%% -*- mode: nitrogen -*-
-module (index).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").

main() -> #template { file="./site/templates/bare.html" }.
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
        #grid_16 { body=placeholder() }
    ]}
].

placeholder() -> [
    #p{},
    #panel{
        style="font:italic small-caps 72px fantasy; text-align:center; color:#fec",
        body="Coming Soon!!"
    }
].


rand_from_pixtab() ->
    Pixtab = [
        "Golden_Moon", "Moonburn",
        "Lunar_eclipse_June_2011", "Solar_eclipse_1999",
        "Solar_eclipse_May_2013"
    ],
    rand_element(Pixtab).


logopix() ->
    Pix = rand_from_pixtab(),
    case Pix of 
        "Solar_eclipse_May_2013" ->
            wf:wire(#script{
                script="document.body.style.background='#130101'"
            });
        _ -> nop
    end,
    #image{
        image="/images/" ++ Pix ++ "_small.jpg",
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

maybe(undefined, Default) -> Default;
maybe(X, _) -> X.
