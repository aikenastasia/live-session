use aiken/fuzz
use cardano/address
use cardano/assets
use cardano/transaction.{Input, NoDatum, Output, OutputReference, Transaction}
use showcase

test check_redeemer_2_test() {
  showcase.check_redeemer.mint(42, "", transaction.placeholder)
}

test mint_nft_positive_test() {
  let utxo = OutputReference("Nonce", 0)
  let redeemer = Void
  let policy_id = "PolicyID"

  let tx =
    Transaction {
      ..transaction.placeholder,
      mint: assets.from_asset(policy_id, "AssetName", 1),
      inputs: [
        Input {
          output_reference: utxo,
          output: Output {
            address: address.from_verification_key("UserWallet"),
            value: assets.from_lovelace(2_000_000),
            datum: NoDatum,
            reference_script: None,
          },
        },
      ],
    }

  showcase.nft.mint(utxo, redeemer, policy_id, tx)
}

test mint_nft_negative_test() fail {
  let utxo = OutputReference("Nonce", 0)
  let redeemer = Void
  let policy_id = "PolicyID"

  let tx =
    Transaction {
      ..transaction.placeholder,
      mint: assets.from_asset(policy_id, "AssetName", 1),
      inputs: [
        Input {
          output_reference: OutputReference("Another", 0),
          output: Output {
            address: address.from_verification_key("UserWallet"),
            value: assets.from_lovelace(2_000_000),
            datum: NoDatum,
            reference_script: None,
          },
        },
      ],
    }

  showcase.nft.mint(utxo, redeemer, policy_id, tx)
}

test burn_nft_positive_test() {
  let utxo = OutputReference("Nonce", 0)
  let redeemer = Void
  let policy_id = "PolicyID"

  let tx =
    Transaction {
      ..transaction.placeholder,
      mint: assets.from_asset(policy_id, "AssetName", -1),
    }

  showcase.nft.mint(utxo, redeemer, policy_id, tx)
}

test mint_nft_invalid_qty(qty via fuzz.int_at_least(2)) fail {
  let utxo = OutputReference("Nonce", 0)
  let redeemer = Void
  let policy_id = "PolicyID"

  let tx =
    Transaction {
      ..transaction.placeholder,
      mint: assets.from_asset(policy_id, "AssetName", qty),
      inputs: [
        Input {
          output_reference: utxo,
          output: Output {
            address: address.from_verification_key("UserWallet"),
            value: assets.from_lovelace(2_000_000),
            datum: NoDatum,
            reference_script: None,
          },
        },
      ],
    }

  showcase.nft.mint(utxo, redeemer, policy_id, tx)
}
