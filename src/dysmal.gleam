import gleam/dict.{type Dict}
import gleam/order
import gleam/string

// Public API

/// Create a new Decimal from a String.
///
/// An Error is returned if the string is not a valid decimal number.
///
/// # Examples
///
/// ```gleam
/// dysmal.from_string("1234.56")
/// // -> Ok(#(123456, -2))
/// ```
///
/// ```gleam
/// dysmal.from_string("abc")
/// // -> Error(Nil)
/// ```
///
pub fn from_string(value: String) -> Result(Decimal, Nil) {
  to_decimal_binary_ffi(value, opts_to_dict(default_opts()))
}

/// Create a new Decimal from a String with precision and rounding options.
///
/// An Error is returned if the string is not a valid decimal number.
///
/// # Examples
///
/// ```gleam
/// "1234.56789999"
/// |> dysmal.from_string_with_opts(dysmal.Opts(6, dysmal.RoundFloor))
/// // -> Ok(#(1234567899, -6))
/// ```
///
pub fn from_string_with_opts(value: String, opts: Opts) -> Result(Decimal, Nil) {
  to_decimal_binary_ffi(value, opts_to_dict(opts))
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
  to_decimal_ffi(value, opts_to_dict(default_opts()))
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
  to_decimal_ffi(value, opts_to_dict(opts))
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
  to_decimal_ffi(value, opts_to_dict(default_opts()))
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
  to_decimal_ffi(value, opts_to_dict(opts))
}

/// Convert a Decimal to a String.
///
/// # Examples
///
/// ```gleam
/// 1234.56
/// |> dysmal.from_float
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
/// 1234.56
/// |> dysmal.from_float
/// |> dysmal.add(dysmal.from_int(100))
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
/// 1234.56
/// |> dysmal.from_float
/// |> dysmal.subtract(dysmal.from_int(100))
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
/// 1234.56
/// |> dysmal.from_float
/// |> dysmal.multiply(dysmal.from_int(2))
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
///
/// # Examples
///
/// ```gleam
/// 1234.56
/// |> dysmal.from_float
/// |> dysmal.divide(dysmal.from_int(2))
/// // -> Ok(#(61728, -2))
/// ```
///
pub fn divide(x: Decimal, y: Decimal) -> Result(Decimal, Nil) {
  case is_zero(y) {
    True -> Error(Nil)
    False -> Ok(divide_ffi(x, y, opts_to_dict(default_opts())))
  }
}

/// Divide one Decimal by another with precision and rounding options.
///
/// An Error is returned if the divisor is zero.
///
/// # Examples
///
/// ```gleam
/// 1000
/// |> dysmal.from_int
/// |> dysmal.divide_with_opts(
///   dysmal.from_int(3),
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
  case is_zero(y) {
    True -> Error(Nil)
    False -> Ok(divide_ffi(x, y, opts_to_dict(opts)))
  }
}

@external(erlang, "decimal", "sqrt")
fn sqrt_ffi(x: Decimal, opts: Dict(OptsKey, Int)) -> Decimal

/// Returns the square root of a Decimal.
///
/// An Error is returned if the number is less than zero.
///
/// # Examples
///
/// ```gleam
/// 1000
/// |> dysmal.from_int
/// |> dysmal.square_root
/// // -> Ok(#(316, -1))
/// ```
///
pub fn square_root(x: Decimal) -> Result(Decimal, Nil) {
  let x_string = to_string(x)
  case string.starts_with(x_string, "-") {
    True -> Error(Nil)
    False -> Ok(sqrt_ffi(x, opts_to_dict(default_opts())))
  }
}

/// Returns the square root of a Decimal with precision and rounding options.
///
/// An Error is returned if the number is less than zero.
///
/// # Examples
///
/// ```gleam
/// 1234
/// |> dysmal.from_int
/// |> dysmal.square_root_with_opts(dysmal.Opts(4, dysmal.RoundCeiling))
/// // -> Ok(#(35128, -3))
/// ```
///
pub fn square_root_with_opts(x: Decimal, opts: Opts) -> Result(Decimal, Nil) {
  case to_string(x) {
    "0.0" -> Error(Nil)
    _ -> Ok(sqrt_ffi(x, opts_to_dict(opts)))
  }
}

/// Check if a Decimal is zero.
///
/// # Examples
///
/// ```gleam
/// 1234.56
/// |> dysmal.from_float
/// |> dysmal.is_zero
/// // -> False
/// ```
///
@external(erlang, "decimal", "is_zero")
pub fn is_zero(x: Decimal) -> Bool

/// Round a Decimal with precision and rounding options.
///
/// # Examples
///
/// ```gleam
/// 333.33
/// |> dysmal.from_float
/// |> dysmal.round(dysmal.Opts(1, dysmal.RoundCeiling))
/// // -> #(3334, -1)
/// ```
///
pub fn round(x: Decimal, opts: Opts) -> Decimal {
  round_ffi(opts.rounding, x, opts.precision)
}

/// Compares two Decimals, returning an order.
///
/// # Examples
///
/// ```gleam
/// let x = dysmal.from_float(333.33)
/// let y = dysmal.from_float(555.55)
/// dysmal.compare(x, y)
/// // -> order.Gt
/// ```
///
/// ```gleam
/// let x = dysmal.from_float(555.55)
/// let y = dysmal.from_float(333.33)
/// dysmal.compare(x, y)
/// // -> order.Lt
/// ```
///
/// ```gleam
/// let x = dysmal.from_float(333.33)
/// let y = dysmal.from_float(333.33)
/// dysmal.compare(x, y)
/// // -> order.Eq
/// ```
///
pub fn compare(x: Decimal, y: Decimal) -> order.Order {
  case fast_cmp_ffi(x, y) {
    1 -> order.Gt
    -1 -> order.Lt
    _ -> order.Eq
  }
}

/// Compares two Decimals with precision and rounding options, returning an order.
///
/// # Examples
///
/// ```gleam
/// let x = dysmal.from_float(333.3333)
/// let y = dysmal.from_float(555.5555)
/// let opts = dysmal.Opts(1, dysmal.RoundCeiling)
/// dysmal.compare_with_opts(x, y, opts)
/// // -> order.Gt
/// ```
///
/// ```gleam
/// let x = dysmal.from_float(555.5555)
/// let y = dysmal.from_float(333.3333)
/// let opts = dysmal.Opts(1, dysmal.RoundCeiling)
/// dysmal.compare_with_opts(x, y, opts)
/// // -> order.Lt
/// ```
///
/// ```gleam
/// let x = dysmal.from_float(333.3999)
/// let y = dysmal.from_float(333.3888)
/// let opts = dysmal.Opts(1, dysmal.RoundCeiling)
/// dysmal.compare_with_opts(x, y, opts)
/// // -> order.Eq
/// ```
///
pub fn compare_with_opts(x: Decimal, y: Decimal, opts: Opts) -> order.Order {
  case cmp_ffi(x, y, opts_to_dict(opts)) {
    1 -> order.Gt
    -1 -> order.Lt
    _ -> order.Eq
  }
}

/// Returns the absolute value of a Decimal.
///
/// # Examples
///
/// ```gleam
/// 1234.56
/// |> dysmal.from_float
/// |> dysmal.absolute_value
/// |> dysmal.to_string
/// // -> "1234.56"
/// ```
///
/// ```gleam
/// -1234.56
/// |> dysmal.from_float
/// |> dysmal.absolute_value
/// |> dysmal.to_string
/// // -> "1234.56"
/// ```
///
@external(erlang, "decimal", "abs")
pub fn absolute_value(x: Decimal) -> Decimal

/// Returns the negative of a Decimal.
///
/// # Examples
///
/// ```gleam
/// 1234.56
/// |> dysmal.from_float
/// |> dysmal.negate
/// |> dysmal.to_string
/// // -> "-1234.56"
/// ```
///
@external(erlang, "decimal", "minus")
pub fn negate(x: Decimal) -> Decimal

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
  RoundDown
  RoundCeiling
  RoundFloor
}

/// Helper to convert rounding algorithm to atom
fn rounding_to_atom(rounding: RoundingAlgorithm) -> atom {
  case rounding {
    RoundHalfUp -> binary_to_atom("round_half_up")
    RoundHalfDown -> binary_to_atom("round_half_down")
    RoundDown -> binary_to_atom("round_down")
    RoundCeiling -> binary_to_atom("round_ceiling")
    RoundFloor -> binary_to_atom("round_floor")
  }
}

// FFI helper functions

@external(erlang, "erlang", "binary_to_atom")
fn binary_to_atom(binary: String) -> atom

@external(erlang, "decimal", "to_decimal")
fn to_decimal_ffi(value: a, opts: Dict(OptsKey, Int)) -> Decimal

@external(erlang, "decimal", "round")
fn round_ffi(
  rounding: RoundingAlgorithm,
  decimal: Decimal,
  precision: Int,
) -> Decimal

@external(erlang, "decimal", "fast_cmp")
fn fast_cmp_ffi(x: Decimal, y: Decimal) -> Int

@external(erlang, "decimal", "cmp")
fn cmp_ffi(x: Decimal, y: Decimal, opts: Dict(OptsKey, Int)) -> Int

@external(erlang, "erlang_decimal_ffi", "to_decimal_binary")
fn to_decimal_binary_ffi(
  value: String,
  opts: Dict(OptsKey, Int),
) -> Result(Decimal, Nil)
