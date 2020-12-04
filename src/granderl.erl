-module(granderl).

-export([
    init/0,
    uniform/1
]).

-compile(no_native).
-on_load(init/0).

load_default() ->
    case code:priv_dir(?MODULE) of
        {error, _} ->
            EbinDir = filename:dirname(code:which(?MODULE)),
            AppPath = filename:dirname(EbinDir),
            filename:join(AppPath, "priv");
        Dir -> Dir
    end.

load_nif() ->
    case os:getenv("NIF_DIR") of
        false -> load_default();
        Path -> Path
    end.


-spec init() -> ok.
init() ->
    SoName = filename:join(load_nif(), "granderl"),
    case catch erlang:load_nif(SoName,[]) of
        _ -> ok
    end.

priv_dir() ->
    case code:priv_dir(?MODULE) of
        {error, _} ->
            EbinDir = filename:dirname(code:which(?MODULE)),
            AppPath = filename:dirname(EbinDir),
            filename:join(AppPath, "priv");
        Dir -> Dir
    end.

-type range() :: 1..4294967295.

-spec uniform(range()) -> range().
uniform(_N) -> erlang:nif_error(granderl_nif_not_loaded).
