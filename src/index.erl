%% -*- mode: nitrogen -*-
-module (index).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").

-type element() :: tuple() |string() | binary(). %todo: all wf elements
-type elements() :: list(element()).
-spec main() -> #template{}.
-spec title() -> string().
-spec desc() -> string().
-spec keywords() -> string().

main() -> #template { file="./site/templates/bare.html" }.
title() -> "luna.inthephase".
desc() -> "All things lunar.".
keywords() -> "moon, moon phases, luna, lunar".


-spec body() -> elements().
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

-spec wire() -> ok.
wire() ->
    wf:wire(main, copyright, #event{ type=mouseover, actions= #fade{} }),
    wf:wire(main, copyright, #event{ type=mouseout, actions= #appear{} }).

-spec copyright() -> #panel{}.
copyright() ->
    #panel{ id=copyright,
        style="font:small-caps 15px normal; text-align:center; color:#aaa",
        body=[ "&copy; ",
            #span{style="font-size:80%", body="2013 "},
            #link{ text="Dual Tech", url="http://dualtech.com.pl" },
            ". All Rigths Reserved."
    ]}.

-spec placeholder() -> elements().
placeholder() -> [
    #p{},
    #panel{
        style="font:italic small-caps 72px fantasy; text-align:center; color:#fec",
        body="Coming Soon!!"
    }
].


-type pix() :: string() | {string(), {atom(), atom()}}.
-spec rand_from_pixtab() -> pix().
rand_from_pixtab() ->
    Pixtab = [
        "Golden_Moon", "Moonburn",
        "Lunar_eclipse_June_2011", "Solar_eclipse_1999",
        {"Solar_eclipse_May_2013", {bg, '#130101'}}
    ],
    maybe(aaa,20),
    rand_element(Pixtab).


-spec moonpix() -> #image{}.
moonpix() -> moonpix(rand_from_pixtab()).

-spec moonpix(pix()) -> #image{}.
moonpix(Pix) ->
    PixName = case Pix of
        {X, {bg, BgColor}} ->
            wf:wire(#script{
                script=wf:f("document.body.style.background=~p", [BgColor])
            }),
            X;
        X -> X
    end,
    wf:wire(moonpix, [#hide{speed=0}, #appear{speed=1000}]),
    #image{
        id=moonpix,
        image="/images/" ++ PixName ++ "_small.jpg",
        style="height:100px" }.


-spec logo() -> elements().
logo() -> [
    #p{},
    #span{ text="luna.inthephase",
        style="font-size:56px; font-family:Tahoma,Arial,sans-serif" },
    #p{}
].


%% helpers

-spec rand_element(list(T)) -> T.
rand_element(Xs) ->
    N = crypto:rand_uniform(1,1+length(Xs)),
    lists:nth(N, Xs).

-spec maybe(T,T) -> T.
maybe(undefined, Default) -> Default;
maybe(X, _) -> X.
