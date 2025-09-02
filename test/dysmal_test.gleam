import dysmal
import gleam/order
import gleeunit

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn from_string_test() {
  let assert Ok(_) = dysmal.from_string("1234.56")

  let actual_2 = dysmal.from_string("abc")

  assert actual_2 == Error(Nil)
}

pub fn zero_from_string_test() {
  let assert Ok(actual) = dysmal.from_string("0")

  assert dysmal.to_string(actual) == "0.0"
}

pub fn negative_from_string_test() {
  let assert Ok(actual) = dysmal.from_string("-1")

  assert dysmal.to_string(actual) == "-1.0"
}

pub fn from_string_with_opts_test() {
  let assert Ok(actual) =
    dysmal.from_string_with_opts(
      "1234.56789999",
      dysmal.Opts(6, dysmal.RoundFloor),
    )

  assert dysmal.to_string(actual) == "1234.567899"
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
    1234.56
    |> dysmal.from_float
    |> dysmal.add(dysmal.from_int(100))
    |> dysmal.to_string

  assert actual == "1334.56"
}

pub fn subtract_test() {
  let actual =
    1234.56
    |> dysmal.from_float
    |> dysmal.subtract(dysmal.from_int(100))
    |> dysmal.to_string

  assert actual == "1134.56"
}

pub fn multiply_test() {
  let actual =
    1234.56
    |> dysmal.from_float
    |> dysmal.multiply(dysmal.from_int(2))
    |> dysmal.to_string

  assert actual == "2469.12"
}

pub fn divide_test() {
  let assert Ok(result) =
    1234.56
    |> dysmal.from_float
    |> dysmal.divide(dysmal.from_int(2))

  let actual = dysmal.to_string(result)

  assert actual == "617.28"
}

pub fn divide_by_zero_test() {
  let actual =
    1234.56
    |> dysmal.from_float
    |> dysmal.divide(dysmal.from_int(0))

  assert actual == Error(Nil)
}

pub fn divide_with_opts_test() {
  let assert Ok(result) =
    1000
    |> dysmal.from_int
    |> dysmal.divide_with_opts(
      dysmal.from_int(3),
      dysmal.Opts(3, dysmal.RoundCeiling),
    )

  let actual = dysmal.to_string(result)

  assert actual == "333.334"
}

pub fn square_root_test() {
  let assert Ok(result) =
    1000
    |> dysmal.from_int
    |> dysmal.square_root

  let actual = dysmal.to_string(result)

  assert actual == "31.6"
}

pub fn square_root_with_opts_test() {
  let assert Ok(result) =
    1234
    |> dysmal.from_int
    |> dysmal.square_root_with_opts(dysmal.Opts(4, dysmal.RoundCeiling))

  let actual = dysmal.to_string(result)

  assert actual == "35.128"
}

pub fn negative_square_root_test() {
  let actual =
    -1
    |> dysmal.from_int
    |> dysmal.square_root

  assert actual == Error(Nil)
}

pub fn is_zero_false_test() {
  let actual =
    1234
    |> dysmal.from_int
    |> dysmal.is_zero

  assert actual == False
}

pub fn is_zero_true_test() {
  let actual =
    0
    |> dysmal.from_int
    |> dysmal.is_zero

  assert actual == True
}

pub fn round_test() {
  let actual =
    333.33
    |> dysmal.from_float
    |> dysmal.round(dysmal.Opts(1, dysmal.RoundCeiling))
    |> dysmal.to_string

  assert actual == "333.4"

  let actual_2 =
    1234.999999
    |> dysmal.from_float_with_opts(dysmal.Opts(6, dysmal.RoundHalfUp))
    |> dysmal.round(dysmal.Opts(2, dysmal.RoundFloor))
    |> dysmal.to_string

  assert actual_2 == "1234.99"
}

pub fn compare_test() {
  let a = dysmal.from_float(333.33)
  let b = dysmal.from_float(555.55)
  assert dysmal.compare(a, b) == order.Lt

  let c = dysmal.from_float(555.55)
  let d = dysmal.from_float(333.33)
  assert dysmal.compare(c, d) == order.Gt

  let e = dysmal.from_float(333.33)
  let f = dysmal.from_float(333.33)
  assert dysmal.compare(e, f) == order.Eq
}

pub fn compare_with_opts_test() {
  let opts = dysmal.Opts(1, dysmal.RoundCeiling)

  let a = dysmal.from_float(333.3333)
  let b = dysmal.from_float(555.5555)
  assert dysmal.compare_with_opts(a, b, opts) == order.Lt

  let c = dysmal.from_float(555.5555)
  let d = dysmal.from_float(333.3333)
  assert dysmal.compare_with_opts(c, d, opts) == order.Gt

  let e = dysmal.from_float(333.3999)
  let f = dysmal.from_float(333.3888)
  assert dysmal.compare_with_opts(e, f, opts) == order.Eq
}

pub fn absolute_value_test() {
  let result =
    1234.56
    |> dysmal.from_float
    |> dysmal.absolute_value
    |> dysmal.to_string

  assert result == "1234.56"
}

pub fn negative_absolute_value_test() {
  let result =
    -1234.56
    |> dysmal.from_float
    |> dysmal.absolute_value
    |> dysmal.to_string

  assert result == "1234.56"
}

pub fn negate_test() {
  let result =
    1234.56
    |> dysmal.from_float
    |> dysmal.negate
    |> dysmal.to_string

  assert result == "-1234.56"
}
