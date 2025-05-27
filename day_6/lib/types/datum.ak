use aiken/collection.{Index}
use aiken/collection/list
use aiken/crypto.{VerificationKeyHash}
use cardano/assets.{AssetName, PolicyId}
use cardano/transaction.{InlineDatum, Transaction}

pub type Datum {
  seller: VerificationKeyHash,
  price: Pairs<PolicyId, Pairs<AssetName, Int>>,
  buyer: Option<VerificationKeyHash>,
  /// double satisfaction protection
  nonce: Int,
}

/// tx |> seller_signed(datum)
pub fn seller_signed(tx: Transaction, datum: Datum) {
  tx.extra_signatories |> list.has(datum.seller)
}

/// tx |> buyer_signed(datum)
pub fn buyer_signed(tx: Transaction, datum: Datum) {
  when datum.buyer is {
    Some(buyer) -> tx.extra_signatories |> list.has(buyer)
    None -> True
  }
}

/// tx |> seller_received_money(output, datum)
pub fn seller_received_money(tx: Transaction, output: Index, datum: Datum) {
  let expected_value = assets.from_asset_list(datum.price)

  // get the output utxo from the specified index, and check its datum nonce
  expect Some(output) = tx.outputs |> list.at(output)
  expect InlineDatum(inline_datum) = output.datum
  expect Datum { nonce, .. } = inline_datum
  expect nonce == datum.nonce

  assets.match(output.value, expected_value, >=)
}
