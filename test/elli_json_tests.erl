-module(elli_json_tests).

-include_lib("eunit/include/eunit.hrl").

postprocess_test() ->
    %% Empty headers
    ?assertEqual({200, body()},
                 elli_json:postprocess(elli_req_record, {200, body()}, [])),

    %% Already compressed
    ?assertEqual({200, headers(), json_body()},
                 elli_json:postprocess(elli_req_record, {200, headers(), json_body()}, [])),

    %% Compress body
    ?assertEqual({200, headers(), json_body()},
                 elli_json:postprocess(elli_req_record, {200, headers(), body()}, [])).

%% Helpers

body() ->
    {[{foo,[<<"bing">>,2.3,true]}]}.

json_body() ->
    <<"{\"foo\":[\"bing\",2.3,true]}">>.

headers() ->
    [{<<"Content-Type">>, <<"application/json">>}].


