%% -*- mode: nitrogen -*-
-module (index).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").

-type element() :: tuple() |string() | binary(). %todo: all wf elements
-type action() :: tuple().
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
body() ->
    {MoonEl, MoonAction} = moonpix(),
    wf:wire(moonpix, [
        #hide{},
        MoonAction,
        #appear{speed=1000}
    ]),
    wf:wire(main, copyright, #event{ type=mouseover, actions= #fade{} }),
    wf:wire(main, copyright, #event{ type=mouseout, actions= #appear{} }),
    [
        #br{},
        #container_16 { body=[
            #grid_3 { id=moonbox, prefix=2, alpha=true, body=MoonEl },
            #grid_7 { suffix=4, omega=true, style="outline:1px dotted",
                body=logo()
            },
            #grid_clear{},
            #grid_16 { id=main, body=placeholder() },
            #p{},
            #grid_16 { body=copyright() }
        ]}
    ].

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
    rand_element(last_moon, Pixtab).


-spec moonpix() -> {#link{}, action()}.
moonpix() -> moonpix(rand_from_pixtab()).

-spec moonpix(pix()) -> {#link{}, action()}.
moonpix(Pix) ->
    {PixName, Bg} = case Pix of
        {X, {bg, BgColor}} ->
            {X, BgColor};
        X -> {X, '#000'}
    end,
    Action = #script{
        script=wf:f("document.body.style.background=~p", [Bg])
    },
    Element = #link{
        postback=pixclicked,
        body= #image{
            id=moonpix,
            image="/images/" ++ PixName ++ "_small.jpg",
            style="height:100px" }},
    {Element, Action}.

new_moonpix() ->
    {Pix, Action} = moonpix(),
    PixSrc = Pix#link.body#image.image,
    wf:wire(moonpix, [
        #fade{speed=1000, actions=[
            #script{script="obj('moonpix').src='"++PixSrc++"'"},
            Action,
            #appear{speed=2000}
        ]}
    ]).
%% results of experiments w/ trigering the right events:
%% - jquery effects are rendered in a way that actions record field
%%   acts as complete() jquery handler
%% - it (probably) should be an array of actions, not a single action
%% - #script doesn't consider actions field


-spec logo() -> elements().
logo() -> [
    #p{},
    #span{ text="luna.inthephase",
        style="font-size:56px; font-family:Tahoma,Arial,sans-serif" },
    #p{}
].

%% events

event(pixclicked) ->
    new_moonpix().

%% helpers

-spec rand_element(atom(), list(T)) -> T.
rand_element(Token, Xs) ->
    Len=length(Xs),
    Last=wf:state_default(Token, Len),
    N = rand_n(Last, Len),
    wf:state(Token, N),
    lists:nth(N, Xs).

rand_n(LastX, N) ->
    X = crypto:rand_uniform(1,1+N),
    case X of
        LastX -> rand_n(LastX, N);
        _ -> X
    end.


-spec maybe(T,T) -> T.
maybe(undefined, Default) -> Default;
maybe(X, _) -> X.

%% -spec runner(fun(()->any())) -> #event{}.
%% runner(F) ->
%%     #event{type=timer, delay=1,
%%         postback={run, F}}.

%% chain_actions(As) ->
%%     lists:foldr(fun chain_actions/2, [], As).
%% chain_actions(A, []) -> [A];
%% chain_actions(A, Bs=[Next|_]) -> 
%%     [ setelement(7,A,Next) | Bs ]. % ugly hack working w/ Nitro 2.1.0
