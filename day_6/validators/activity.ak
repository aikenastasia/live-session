use aiken/collection.{Index}
use cardano/transaction.{OutputReference, Transaction}
use types/datum.{Datum}

validator picoswap {
  spend(
    datum: Option<Datum>,
    redeemer output: Index,
    _o_ref: OutputReference,
    tx: Transaction,
  ) {
    expect Some(datum) = datum
    or {
      tx |> datum.seller_signed(datum),
      and {
        tx |> datum.buyer_signed(datum),
        tx |> datum.seller_received_money(output, datum),
      },
    }
  }

  else(_) {
    fail
  }
}
