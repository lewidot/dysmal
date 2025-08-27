import gleam/dict.{type Dict}

// Public API

/// Create a new Decimal from a String.
///
/// # Examples
///
/// ```gleam
/// dysmal.from_string("1234.56")
/// // -> #(123456, -2)
/// ```
///
pub fn from_string(value: String) -> Decimal {
  to_decimal_raw(value, opts_to_dict(default_opts()))
}

/// Create a new Decimal from a String with precision and rounding options.
///
/// # Examples
///
/// ```gleam
/// "1234.56789999"
/// |> dysmal.from_string_with_opts(dysmal.Opts(6, dysmal.RoundFloor))
/// // -> #(1234567899, -6)
/// ```
///
pub fn from_string_with_opts(value: String, opts: Opts) -> Decimal {
  to_decimal_raw(value, opts_to_dict(opts))
}

/// Create a new Decimal from a Float.
///
/// # Examples
///
/// ```gleam
/// dysmal.from_float(1234.56)
/// // -> #(123456, -2)
/// ```
///
pub fn from_float(value: Float) -> Decimal {
  to_decimal_raw(value, opts_to_dict(default_opts()))
}

/// Create a new Decimal from a Float with precision and rounding options.
///
/// # Examples
///
/// ```gleam
/// 1234.56781111
/// |> dysmal.from_float_with_opts(dysmal.Opts(4, dysmal.RoundCeiling))
/// // -> #(12345679, -4)
/// ```
///
pub fn from_float_with_opts(value: Float, opts: Opts) -> Decimal {
  to_decimal_raw(value, opts_to_dict(opts))
}

/// Create a new Decimal from an Int.
///
/// # Examples
///
/// ```gleam
/// dysmal.from_int(1234)
/// // -> #(1234, 0)
/// ```
///
pub fn from_int(value: Int) -> Decimal {
  to_decimal_raw(value, opts_to_dict(default_opts()))
}

/// Create a new Decimal from an Int with precision and rounding options.
///
/// # Examples
///
/// ```gleam
/// 1234
/// |> dysmal.from_int_with_opts(dysmal.Opts(4, dysmal.RoundCeiling))
/// // -> #(1234, 0)
/// ```
///
pub fn from_int_with_opts(value: Int, opts: Opts) -> Decimal {
  to_decimal_raw(value, opts_to_dict(opts))
}

/// Convert a Decimal to a String.
///
/// # Examples
///
/// ```gleam
/// "1234.56"
/// |> dysmal.from_string
/// |> dysmal.to_string
/// // -> "1234.56"
/// ```
///
@external(erlang, "decimal", "to_binary")
pub fn to_string(decimal: Decimal) -> String

/// Add two Decimal numbers together.
///
/// # Examples
///
/// ```gleam
/// "1234.56"
/// |> dysmal.from_string
/// |> dysmal.add(dysmal.from_string("100"))
/// |> dysmal.to_string
/// // -> "1334.56"
/// ```
///
@external(erlang, "decimal", "add")
pub fn add(x: Decimal, y: Decimal) -> Decimal

/// Subtract one Decimal from another.
///
/// # Examples
///
/// ```gleam
/// "1234.56"
/// |> dysmal.from_string
/// |> dysmal.subtract(dysmal.from_string("100"))
/// |> dysmal.to_string
/// // -> "1134.56"
/// ```
///
@external(erlang, "decimal", "sub")
pub fn subtract(x: Decimal, y: Decimal) -> Decimal

/// Multiply one Decimal by another.
///
/// # Examples
///
/// ```gleam
/// "1234.56"
/// |> dysmal.from_string
/// |> dysmal.multiply(dysmal.from_string("2))
/// |> dysmal.to_string
/// // -> "2469.12"
/// ```
///
@external(erlang, "decimal", "mult")
pub fn multiply(x: Decimal, y: Decimal) -> Decimal

@external(erlang, "decimal", "divide")
fn divide_ffi(x: Decimal, y: Decimal, opts: Dict(OptsKey, Int)) -> Decimal

/// Divide one Decimal by another.
///
/// An Error is returned if the divisor is zero.
/// # Examples
///
/// ```gleam
/// "1234.56"
/// |> dysmal.from_string
/// |> dysmal.divide(dysmal.from_string("2"))
/// // -> Ok(#(61728, -2))
/// ```
///
pub fn divide(x: Decimal, y: Decimal) -> Result(Decimal, Nil) {
  case to_string(y) {
    "0.0" -> Error(Nil)
    _ -> Ok(divide_ffi(x, y, opts_to_dict(default_opts())))
  }
}

/// Divide one Decimal by another with precision and rounding options.
///
/// An Error is returned if the divisor is zero.
/// # Examples
///
/// ```gleam
/// "1000"
/// |> dysmal.from_string
/// |> dysmal.divide_with_opts(
///   dysmal.from_string("3"),
///   dysmal.Opts(3, dysmal.RoundCeiling),
/// )
/// // -> Ok(#(333334, -3))
/// ```
///
pub fn divide_with_opts(
  x: Decimal,
  y: Decimal,
  opts: Opts,
) -> Result(Decimal, Nil) {
  case to_string(y) {
    "0.0" -> Error(Nil)
    _ -> Ok(divide_ffi(x, y, opts_to_dict(opts)))
  }
}

// Types

/// Representation of a decimal number.
///
pub type Decimal

/// Options type for precision and rounding.
///
pub type Opts {
  Opts(precision: Int, rounding: RoundingAlgorithm)
}

/// Default options for precision and rounding.
///
fn default_opts() -> Opts {
  Opts(2, RoundHalfUp)
}

/// Dict keys for the opts argument for `to_decimal/2`.
///
type OptsKey {
  Precision
  Rounding
}

/// Convert Opts type to a Dict.
///
fn opts_to_dict(opts: Opts) -> Dict(OptsKey, Int) {
  // Extract the values from Opts
  let Opts(precision, rounding) = opts

  // Convert `rounding` to an Erlang atom
  let rounding_atom = rounding_to_atom(rounding)

  // Build the dict that the `to_decimal/2` function expects
  dict.new()
  |> dict.insert(Precision, precision)
  |> dict.insert(Rounding, rounding_atom)
}

// Rounding algorithm type
pub type RoundingAlgorithm {
  RoundHalfUp
  RoundHalfDown
  RoundHalfEven
  RoundUp
  RoundDown
  RoundCeiling
  RoundFloor
}

/// Helper to convert rounding algorithm to atom
fn rounding_to_atom(rounding: RoundingAlgorithm) -> atom {
  case rounding {
    RoundHalfUp -> binary_to_atom("round_half_up")
    RoundHalfDown -> binary_to_atom("round_half_down")
    RoundHalfEven -> binary_to_atom("round_half_even")
    RoundUp -> binary_to_atom("round_up")
    RoundDown -> binary_to_atom("round_down")
    RoundCeiling -> binary_to_atom("round_ceiling")
    RoundFloor -> binary_to_atom("round_floor")
  }
}

// FFI helper functions

@external(erlang, "erlang", "binary_to_atom")
fn binary_to_atom(binary: String) -> atom

@external(erlang, "decimal", "to_decimal")
fn to_decimal_raw(value: a, opts: Dict(OptsKey, Int)) -> Decimal
