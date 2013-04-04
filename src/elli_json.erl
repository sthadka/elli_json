%% @doc Convert response body to JSON
-module(elli_json).
-export([postprocess/3]).

%% Do not convert to JSON when response has no headers
postprocess(_Req, {ResponseCode, Body}, _Config) ->
    {ResponseCode, Body};

postprocess(_Req, {ResponseCode, Headers, Body} = Res, _Config)
        when is_integer(ResponseCode) orelse ResponseCode =:= ok ->
    case should_convert(Headers, Body) of
        false ->
            Res;
        true ->
            {ResponseCode, Headers, jiffy:encode(Body)}
    end;

postprocess(_, Res, _) ->
    Res.

%% Helpers

should_convert(Headers, Body) ->
    case proplists:get_value(<<"Content-Type">>, Headers) of
        <<"application/json">> ->
            not is_binary(Body);
        _ ->
            false
    end.
