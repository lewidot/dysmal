import gleam/dict.{type Dict}

@external(erlang, "erlang", "binary_to_atom")
fn binary_to_atom(binary: String) -> atom

@external(erlang, "decimal", "to_binary")
fn to_binary(decimal: Decimal) -> String

@external(erlang, "decimal", "to_decimal")
fn to_decimal_raw(value: a, opts: Dict(OptsKey, Int)) -> Decimal

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

/// Create a new Decimal from a string.
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
pub fn to_string(decimal: Decimal) -> String {
  to_binary(decimal)
}
