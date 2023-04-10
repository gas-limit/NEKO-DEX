import React, { useState, useEffect } from "react";
import "./styles.css";

import { WETHUSDCMODAL } from "./swapWETHUSDC.js";
import { WBTCUSDCMODAL } from "./swapWBTCUSDC.js";
import { OPUSDCMODAL } from "./swapOPUSDC.js";
import { DAIUSDCMODAL } from "./swapDAIUSDC.js";

export default function SwapPoolView() {
  const [WETHUSDC, setWETHUSDC] = useState();
  const [WBTCUSDC, setWBTCUSDC] = useState();
  const [OPUSDC, setOPUSDC] = useState();

  const [DAIUSDC, setDAIUSDC] = useState();
  const [poolview, setPoolview] = useState(true);

  function viewWETHUSDC() {
    setWETHUSDC(true);
    setPoolview(false);
  }

  function viewWBTCUSDC() {
    setWBTCUSDC(true);
    setPoolview(false);
  }

  function viewOPUSDC() {
    setOPUSDC(true);
    setPoolview(false);
  }

  function viewDAIUSDC() {
    setDAIUSDC(true);
    setPoolview(false);
  }

  function viewNone() {
    setWETHUSDC(false);
    setDAIUSDC(false);
    setOPUSDC(false);
    setWBTCUSDC(false);
    setPoolview(true);
  }

  return (
    <>
      {" "}
      {poolview && (
        <div className="poolView">
          <h1> Neko Exchange </h1>

          <table>
            <tr>
              <th>Pool</th>
              <th>Volume</th>
              <th>TVL</th>
            </tr>
            <tr onClick={() => viewWETHUSDC()}>
              <td>
                {" "}
                <div className="poolContent">
                  <img
                    className="tokenIcon"
                    src="https://w7.pngwing.com/pngs/383/521/png-transparent-eth-crypto-cryptocurrency-cryptocurrencies-cash-money-bank-payment-icon.png"
                  />
                  <img
                    className="tokenIcon"
                    src="https://cryptologos.cc/logos/usd-coin-usdc-logo.png"
                  />{" "}
                  <div>
                    <b> Eth-Choco Chip Cookie Dough </b> <br />
                    WETH / USDC
                  </div>
                </div>
              </td>
              <td>-</td>
              <td>-</td>
            </tr>

            <tr onClick={() => viewWBTCUSDC(true)}>
              <td>
                <div className="poolContent">
                  <img
                    className="tokenIcon"
                    src="https://upload.wikimedia.org/wikipedia/commons/thumb/4/46/Bitcoin.svg/1200px-Bitcoin.svg.png"
                  />
                  <img
                    className="tokenIcon"
                    src="https://cryptologos.cc/logos/usd-coin-usdc-logo.png"
                  />
                  <div>
                    <b> WBTC Ube Pandasal </b> <br />
                    WBTC / USDC
                  </div>
                </div>
              </td>
              <td>-</td>
              <td>-</td>
            </tr>
            <tr onClick={() => viewOPUSDC(true)}>
              <td>
                <div className="poolContent">
                  <img
                    className="tokenIcon"
                    src="https://cryptologos.cc/logos/optimism-ethereum-op-logo.png"
                  />
                  <img
                    className="tokenIcon"
                    src="https://cryptologos.cc/logos/usd-coin-usdc-logo.png"
                  />
                  <div>
                    <b> Opti-Fruit Tart </b> <br />
                    OP / USDC
                  </div>
                </div>
              </td>
              <td>-</td>
              <td>-</td>
            </tr>
            <tr onClick={() => viewDAIUSDC(true)}>
              <td>
                <div className="poolContent">
                  <img
                    className="tokenIcon"
                    src="https://cryptologos.cc/logos/multi-collateral-dai-dai-logo.png"
                  />
                  <img
                    className="tokenIcon"
                    src="https://cryptologos.cc/logos/usd-coin-usdc-logo.png"
                  />
                  <div>
                    {" "}
                    <b> Stablecoin Strudel </b> <br />
                    DAI / USDC
                  </div>
                </div>
              </td>
              <td>-</td>
              <td>-</td>
            </tr>
          </table>
        </div>
      )}
      {WETHUSDC && <WETHUSDCMODAL />}
      {WBTCUSDC && <WBTCUSDCMODAL />}
      {OPUSDC && <OPUSDCMODAL />}
      {DAIUSDC && <DAIUSDCMODAL />}
      {(WETHUSDC || WBTCUSDC || OPUSDC || DAIUSDC || WETHUSDC) && (
        <button onClick={() => viewNone(false)}>Back</button>
      )}
    </>
  );
}
