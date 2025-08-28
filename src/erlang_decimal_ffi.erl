-module(erlang_decimal_ffi).
-export([
    to_decimal_binary/2
]).

to_decimal_binary(Value, Opts) ->
    try {ok, decimal:to_decimal(Value, Opts)}
    catch error:badarg -> {error, nil}
    end.
