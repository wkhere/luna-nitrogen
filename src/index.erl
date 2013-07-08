%% -*- mode: nitrogen -*-
-module (index).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").

main() -> #template { file="./site/templates/bare.html" }.

debug_css() ->
    %% todo: turn on conditionally
    "<link rel='stylesheet' href='/css/debug.css' />".

title() -> "Welcome to Nitrogen".

body() ->
    #container_16 { body=[
        #grid_12 { prefix=2, suffix=2, alpha=true, omega=true,
            body=inner_body()
        }
    ]}.

inner_body() -> 
    [
        #h1 { text="Welcome to Nitrogen" },
        #p{},
        "
        If you can see this page, then your Nitrogen server is up and
        running. Click the button below to test postbacks.
        ",
        #p{},
        #grid_clear{},
        #grid_2 { alpha=true, body=[
            #button{ id=button, text="Click me!", 
                postback=click }
        ]},
        #grid_4 { id=button_comment_box, omega=true, body=[]},
        #grid_clear{},
		#p{},
        #textbox {id=t1, next=t2, placeholder="Foo", postback=t1pb},
        #br{}, #textbox {id=t2, text="Bar"},
        #p{},
        "
        Run <b>./bin/dev help</b> to see some useful developer commands.
        ",
		#p{},
		"
		<b>Want to see the ",#link{text="Sample Nitrogen jQuery Mobile Page",url="/mobile"},"?</b>
		"
    ].
	
event(t1pb) ->
    ?PRINT(t1pb);

event(click) ->
    wf:replace(button, #button { id=button, text="Click me again",
        postback=click }),
    wf:update(button_comment_box,
        #span{ text="You clicked the button!",
            actions=[#fade{speed=1000}]
    }).
