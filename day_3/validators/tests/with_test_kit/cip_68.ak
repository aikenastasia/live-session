use cardano/address
use cardano/assets
use cardano/transaction.{InlineDatum, OutputReference}
use showcase
use showcase/types/cip68.{Cip68}
use test_kit.{to_data}
use test_kit/tx.{
  add_asset_to_tx_output, add_tx_input, add_tx_output, new_tx_input,
  new_tx_output, set_datum_of_tx_input, set_datum_of_tx_output,
  with_asset_of_tx_input,
}

test validate_update_cip_68() {
  let script_hash = "SC_Cip68"
  let script_addr = address.from_script(script_hash)

  let ref_token = assets.from_asset(script_hash, #"000643b0abcd", 1)
  let usr_token = assets.from_asset(script_hash, #"000de140abcd", 1)

  let in_datum =
    Cip68 {
      metadata: [
        Pair("name", "abcd" |> to_data),
        Pair("image", "ipfs://..." |> to_data),
      ],
      version: 1,
      extra: [],
    }
  let out_datum =
    Cip68 {
      metadata: [
        Pair("name", "abcdef" |> to_data),
        Pair("image", "ipfs://..." |> to_data),
      ],
      version: 1,
      extra: [],
    }

  let o_ref = OutputReference("A", 1)

  let ref_token_utxo_in =
    new_tx_input(o_ref, script_addr)
      |> set_datum_of_tx_input(in_datum |> InlineDatum)
      |> with_asset_of_tx_input(ref_token)

  let usr_token_utxo_in =
    new_tx_input(
      OutputReference("B", 2),
      address.from_verification_key("UserKey"),
    )
      |> with_asset_of_tx_input(usr_token)

  let ref_token_utxo_out =
    new_tx_output(script_addr)
      |> set_datum_of_tx_output(out_datum |> InlineDatum)
      |> add_asset_to_tx_output(ref_token)

  let tx =
    transaction.placeholder
      |> add_tx_input(ref_token_utxo_in)
      |> add_tx_input(usr_token_utxo_in)
      |> add_tx_output(ref_token_utxo_out)

  showcase.cip_68.spend(Some(in_datum), Void, o_ref, tx)
}
