import { Button } from "@heroui/button";
import { Snippet } from "@heroui/snippet";
import { Address, Koios, Lucid, LucidEvolution, WalletApi } from "@lucid-evolution/lucid";
import { useState } from "react";

export default function Home() {
  type Wallet = {
    name: string;
    icon: string;
    apiVersion: string;
    enable(): Promise<WalletApi>;
    isEnabled(): Promise<boolean>;
  };

  function getWallets() {
    const wallets: Wallet[] = [];
    const { cardano } = window;

    for (const c in cardano) {
      const wallet = cardano[c];

      if (!wallet.apiVersion) continue;

      wallets.push(wallet);
    }

    return wallets.sort((l, r) => {
      return l.name.toUpperCase() < r.name.toUpperCase() ? -1 : 1;
    });
  }

  const wallets = getWallets();

  type Connection = {
    lucid: LucidEvolution;
    api: WalletApi;

    address: Address;
  };

  async function connect(wallet: Wallet): Promise<Connection> {
    const [lucid, api] = await Promise.all([Lucid(new Koios("/koios"), "Preview"), wallet.enable()]);

    lucid.selectWallet.fromAPI(api);

    const address = await lucid.wallet().address();

    return { lucid, api, address };
  }

  const [connection, setConnection] = useState<Connection>();

  async function doSomething(message: string, { lucid, api }: Connection) {
    if (!lucid.wallet()) lucid.selectWallet.fromAPI(api);

    const tx = await lucid
      .newTx()
      .attachMetadata(674, { msg: [message] })
      .complete();

    const txSigned = await tx.sign.withWallet().complete();
    const txHash = await txSigned.submit();

    return txHash;
  }

  const [result, setResult] = useState("");

  return (
    <div className="flex flex-col items-center gap-2">
      {wallets.length ? (
        <div className="flex flex-wrap gap-2">
          {wallets.map((wallet, w) => (
            <Button
              key={`wallet.${w}`}
              className="bg-gradient-to-tr from-pink-500 to-yellow-500 text-white shadow-lg capitalize"
              radius="full"
              onPress={() => connect(wallet).then(setConnection).catch(console.log)}
            >
              {wallet.name}
            </Button>
          ))}
        </div>
      ) : (
        <span>NO CARDANO WALLET</span>
      )}

      {connection && (
        <div className="flex flex-col items-center gap-2">
          <Snippet hideCopyButton hideSymbol variant="bordered">
            <span>{connection.address}</span>
          </Snippet>

          <Button
            className="bg-gradient-to-tr from-pink-500 to-yellow-500 text-white shadow-lg max-w-fit"
            radius="full"
            onPress={() => doSomething("Hello, Lucid!", connection).then(setResult).catch(console.log)}
          >
            Do Something
          </Button>

          <span>{result}</span>
        </div>
      )}
    </div>
  );
}
