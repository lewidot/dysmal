# dysmal

[![Package Version](https://img.shields.io/hexpm/v/dysmal)](https://hex.pm/packages/dysmal)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/dysmal/)
![Erlang Target](https://img.shields.io/badge/target-erlang-A90433)

Typesafe bindings to the [erlang_decimal](https://github.com/egobrain/decimal) package.

```sh
gleam add dysmal
```

```gleam
import dysmal

pub fn main() -> Nil {
  123.45
  |> dysmal.from_float
  |> dysmal.multiply(dysmal.from_int(3))
  |> dysmal.to_string
  |> io.println // "370.35"
}
```

Further documentation can be found at <https://hexdocs.pm/dysmal>.

## Development

```sh
gleam test  # Run the tests
```
