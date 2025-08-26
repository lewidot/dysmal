import dysmal
import gleeunit

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn from_string_test() {
  let actual =
    dysmal.from_string("1234.56")
    |> dysmal.to_string

  assert actual == "1234.56"
}

pub fn from_string_with_opts_test() {
  let actual =
    dysmal.from_string_with_opts(
      "1234.56789999",
      dysmal.Opts(6, dysmal.RoundFloor),
    )
    |> dysmal.to_string

  assert actual == "1234.567899"
}

pub fn from_float_test() {
  let actual =
    dysmal.from_float(1234.56)
    |> dysmal.to_string

  assert actual == "1234.56"
}

pub fn from_float_with_opts_test() {
  let actual =
    dysmal.from_float_with_opts(
      1234.56781111,
      dysmal.Opts(4, dysmal.RoundCeiling),
    )
    |> dysmal.to_string

  assert actual == "1234.5679"
}

pub fn from_int_test() {
  let actual =
    dysmal.from_int(1234)
    |> dysmal.to_string

  assert actual == "1234.0"
}

pub fn from_int_with_opts_test() {
  let actual =
    dysmal.from_int_with_opts(1234, dysmal.Opts(6, dysmal.RoundCeiling))
    |> dysmal.to_string

  assert actual == "1234.0"
}

pub fn add_test() {
  let actual =
    "1234.56"
    |> dysmal.from_string
    |> dysmal.add(dysmal.from_string("100"))
    |> dysmal.to_string

  assert actual == "1334.56"
}
