%% -*- mode: nitrogen -*-
-module (index).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").

main() -> #template { file="./site/templates/bare.html" }.
title() -> "luna.inthephase".
desc() -> "All things lunar.".
keywords() -> "moon, moon phases, luna, lunar".
    
body() -> wire(), [
    #br{},
    #container_16 { body=[
        #grid_3 { prefix=2, alpha=true, body=moonpix() },
        #grid_7 { suffix=4, omega=true, style="outline:1px dotted",
            body=logo()
        },
        #grid_clear{},
        #grid_16 { id=main, body=placeholder() },
        #p{},
        #grid_16 { body=copyright() }
    ]}
].

wire() ->
    wf:wire(main, copyright, #event{ type=mouseover, actions= #fade{} }),
    wf:wire(main, copyright, #event{ type=mouseout, actions= #appear{} }).

copyright() ->
    #panel{ id=copyright,
        style="font:small-caps 15px normal; text-align:center; color:#aaa",
        body=[ "&copy; ",
            #span{style="font-size:80%", body="2013 "},
            #link{ text="Dual Tech", url="http://dualtech.com.pl" },
            ". All Rigths Reserved."
    ]}.


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
        {"Solar_eclipse_May_2013", {bg, '#130101'}}
    ],
    rand_element(Pixtab).


moonpix() -> moonpix(rand_from_pixtab()).

moonpix(Pix) ->
    PixName = case Pix of
        {X, {bg, BgColor}} ->
            wf:wire(#script{
                script=wf:f("document.body.style.background=~p", [BgColor])
            }),
            X;
        X -> X
    end,
    #image{
        image="/images/" ++ PixName ++ "_small.jpg",
        style="height:100px" }.

logo() -> [
    #p{},
    #span{ text="luna.inthephase",
        style="font-size:56px; font-family:Tahoma,Arial,sans-serif" },
    #p{}
].


%% helpers

rand_element(Xs) ->
    N = crypto:rand_uniform(1,1+length(Xs)),
    lists:nth(N, Xs).

maybe(undefined, Default) -> Default;
maybe(X, _) -> X.
