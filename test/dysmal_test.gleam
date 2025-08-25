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
