use aiken/cbor

test integer() {
  let i: Int = 5_000_000
  let n = 5000000

  i == n
}

test bytearray() {
  let a: ByteArray = "abcd"
  let b = #"abcd"

  trace @"bytearray": a, b

  a != b
}

test list_test() {
  let ls = [1, 2, 3]

  [4, ..ls] == [4, 1, 2, 3]
}

type Person {
  name: ByteArray,
  age: Int,
}

type Nameless {
  Constr(Int, Bool, ByteArray)
}

type Newtype {
  field: Int,
}

opaque type OpaqueType {
  field: Int,
}

test newtype() {
  let nt = Newtype(1)
  trace cbor.serialise(nt)

  let ot = OpaqueType(1)
  trace cbor.serialise(ot)

  True
}

test person() {
  let p1 = Person { age: 10, name: "Andy" }
  let p2 = Person { ..p1, age: 20 }

  let n0: Nameless = Constr(0, False, "")
  trace n0

  let Constr(age, _, _) = n0
  trace @"n0": age

  p1.name == p2.name
}

pub type TrafficLight {
  Red { duration: Int, f2: ByteArray, f3: Bool }
  Yellow { location: ByteArray }
  Green { is_on: ByteArray }
}

// Blue { fb: fn() -> Int }

test multiconstr() {
  let l1: TrafficLight = Red(60, "", True)
  let l2 = Yellow { location: "There" }

  expect Red { f3: is_on, .. } = l1
  trace @"Red": is_on

  let not_red =
    when l2 is {
      Red { .. } -> False
      Yellow { .. } | Green { .. } -> True
    }

  not_red
}
