use day_1/placeholder.{Red}

test import() {
  let light = Red { duration: 30, f2: "Red", f3: True }
  expect Red { f3, .. } = light
  f3
}
