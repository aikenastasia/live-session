use cardano/address
use cardano/assets
use cardano/transaction.{
  InlineDatum, Input, NoDatum, Output, OutputReference, Transaction,
}
use showcase
use showcase/types/cip68.{Cip68}

test validate_update_cip_68() {
  let script_hash = "SC_Cip68"
  let script_addr = address.from_script(script_hash)

  let ref_token = assets.from_asset(script_hash, #"000643b0abcd", 1)
  let usr_token = assets.from_asset(script_hash, #"000de140abcd", 1)

  let initial_name: Data = "abcd"
  let updated_name: Data = "abcdef"

  let image_url: Data = "ipfs://..."

  let in_datum =
    Cip68 {
      metadata: [Pair("name", initial_name), Pair("image", image_url)],
      version: 1,
      extra: [],
    }
  let out_datum =
    Cip68 {
      metadata: [Pair("name", updated_name), Pair("image", image_url)],
      version: 1,
      extra: [],
    }

  let o_ref = OutputReference("A", 1)

  let tx =
    Transaction {
      ..transaction.placeholder,
      inputs: [
        // RefToken UTxO
        Input {
          output_reference: o_ref,
          output: Output {
            address: script_addr,
            value: ref_token,
            datum: InlineDatum(in_datum),
            reference_script: None,
          },
        },
        // UsrToken UTxO
        Input {
          output_reference: OutputReference("B", 2),
          output: Output {
            address: address.from_verification_key("UserKey"),
            value: usr_token,
            datum: NoDatum,
            reference_script: None,
          },
        },
      ],
      outputs: [
        Output {
          address: script_addr,
          value: ref_token,
          datum: InlineDatum(out_datum),
          reference_script: None,
        },
      ],
    }

  showcase.cip_68.spend(Some(in_datum), Void, o_ref, tx)
}
