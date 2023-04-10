import { urlToRequest } from "loader-utils";
import React, { useState, useEffect } from "react";
import "./styles.css";

import SwapPoolView from "./swapPoolView.js";
import StickyBoard from "./stickyNotes";

import leftImage from "./assets/left.gif";
import rightImage from "./assets/right.gif";
import idleImage from "./assets/idle.gif";
import downImage from "./assets/down.gif";
import upImage from "./assets/up.gif";

import worker from "./assets/worker.gif";

const BOX_HEIGHT = 600;
const BOX_WIDTH = 800;
const BOX_COLOR = "#ccc";
const INNER_BOX_SIZE = 70;
const INNER_BOX_COLOR = "blue";
const KEY_CODES = {
  W: 87,
  A: 65,
  S: 83,
  D: 68
};
const OBSTACLE_WIDTH = 75;
const OBSTACLE_HEIGHT = 300;

const MODAL_TEXT = "You have opened the DEX";

const BOARD_WIDTH = 230;
const BOARD_HEIGHT = 50;

const BOARD_TEXT = "You are looking at the sticky board";

export default function App() {
  const [innerBoxPosition, setInnerBoxPosition] = useState({
    top: 500,
    left: 255
  });
  const [showDEX, setShowDEX] = useState(false);
  const [showBoard, setShowBoard] = useState(false);

  const [showDEXText, setShowDEXText] = useState(false);
  const [showBoardText, setShowBoardText] = useState(false);

  const [direction, setDirection] = useState("left");

  const [collision, setCollision] = useState(false);

  const [nekoText, setNekoText] = useState(false);

  const [showNeko, setShowNeko] = useState(false);

  const [isIdle, setIsIdle] = useState(true);

  useEffect(() => {
    function handleKeyPress(event) {
      const { keyCode } = event;
      const { top, left } = innerBoxPosition;
      const maxTop = BOX_HEIGHT - INNER_BOX_SIZE;
      const maxLeft = BOX_WIDTH - INNER_BOX_SIZE;
      const minTop = 0;
      const minLeft = 0;

      switch (keyCode) {
        case KEY_CODES.W:
          setInnerBoxPosition({ top: Math.max(minTop + 140, top - 10), left });
          setDirection("up");
          setIsIdle(false);
          break;
        case KEY_CODES.A:
          setInnerBoxPosition({
            top,
            left: Math.max(minLeft + 185, left - 10)
          });
          setDirection("left");
          setIsIdle(false);
          break;
        case KEY_CODES.S:
          setInnerBoxPosition({ top: Math.min(maxTop, top + 10), left });
          setDirection("down");
          setIsIdle(false);
          break;
        case KEY_CODES.D:
          setInnerBoxPosition({ top, left: Math.min(maxLeft, left + 10) });
          setDirection("right");
          setIsIdle(false);
          break;
        default:
          setIsIdle(true);
          break;
      }
    }

    window.addEventListener("keydown", handleKeyPress);

    return () => {
      window.removeEventListener("keydown", handleKeyPress);
    };
  }, [innerBoxPosition]);

  useEffect(() => {
    function checkCollision() {
      const innerBoxRect = document
        .querySelector(".inner-box")
        .getBoundingClientRect();
      const obstacleRect = document
        .querySelector(".obstacle")
        .getBoundingClientRect();
      const boardRect = document
        .querySelector(".board")
        .getBoundingClientRect();
      const table1Rect = document
        .querySelector(".table1")
        .getBoundingClientRect();
      const table2Rect = document
        .querySelector(".table2")
        .getBoundingClientRect();

      const catRect = document.querySelector(".neko").getBoundingClientRect();

      if (
        !showDEX &&
        !showBoard &&
        innerBoxRect.left < obstacleRect.right &&
        innerBoxRect.right > obstacleRect.left &&
        innerBoxRect.top < obstacleRect.bottom &&
        innerBoxRect.bottom > obstacleRect.top
      ) {
        setShowBoardText(false);
        setShowDEXText(true);
      }
      if (
        !showDEX &&
        !showBoard &&
        innerBoxRect.left < boardRect.right &&
        innerBoxRect.right > boardRect.left &&
        innerBoxRect.top < boardRect.bottom &&
        innerBoxRect.bottom > boardRect.top
      ) {
        setShowDEXText(false);
        setShowBoardText(true);
      }

      if (
        innerBoxRect.left < table1Rect.right &&
        innerBoxRect.right > table1Rect.left &&
        innerBoxRect.top < table1Rect.bottom &&
        innerBoxRect.bottom > table1Rect.top
      ) {
      }

      if (
        innerBoxRect.left < table2Rect.right &&
        innerBoxRect.right > table2Rect.left &&
        innerBoxRect.top < table2Rect.bottom &&
        innerBoxRect.bottom > table2Rect.top
      ) {
      }
      if (
        innerBoxRect.left < catRect.right &&
        innerBoxRect.right > catRect.left &&
        innerBoxRect.top < catRect.bottom &&
        innerBoxRect.bottom > catRect.top
      ) {
        setNekoText(true);
      }
      if (
        !(
          innerBoxRect.left < catRect.right &&
          innerBoxRect.right > catRect.left &&
          innerBoxRect.top < catRect.bottom &&
          innerBoxRect.bottom > catRect.top
        )
      ) {
        setNekoText(false);
        setShowNeko(false);
      }
      if (
        !showDEX &&
        !showBoard &&
        innerBoxRect.left < obstacleRect.right &&
        innerBoxRect.right > obstacleRect.left &&
        innerBoxRect.top < obstacleRect.bottom &&
        innerBoxRect.bottom > obstacleRect.top
      ) {
        setShowBoardText(false);
        setShowDEXText(true);
      }
      if (
        !(
          innerBoxRect.left - 30 < obstacleRect.right &&
          innerBoxRect.right + 30 > obstacleRect.left &&
          innerBoxRect.top - 30 < obstacleRect.bottom &&
          innerBoxRect.bottom + 30 > obstacleRect.top
        )
      ) {
        setShowDEXText(false);
      }

      if (
        !(
          innerBoxRect.left - 30 < boardRect.right &&
          innerBoxRect.right + 30 > boardRect.left &&
          innerBoxRect.top - 30 < boardRect.bottom &&
          innerBoxRect.bottom + 30 > boardRect.top
        )
      ) {
        setShowBoardText(false);
      }
    }

    checkCollision();
  }, [innerBoxPosition]);

  function showDexFunc() {
    setShowDEX(true);
    setShowDEXText(false);
  }

  function showBoardFunc() {
    setShowBoard(true);
    setShowBoardText(false);
  }

  function Neko() {
    setNekoText(false);
    setShowNeko(true);
  }

  const getImage = () => {
    if (isIdle) {
      return idleImage;
    } else {
      switch (direction) {
        case "left":
          return leftImage;
        case "right":
          return rightImage;
        case "up":
          return upImage;
        case "down":
          return downImage;
        default:
          return idleImage;
      }
    }
  };

  useEffect(() => {
    const interval = setInterval(() => {
      setIsIdle(true);
    }, 300);

    return () => clearInterval(interval);
  }, [innerBoxPosition]);

  return (
    <div className="container">
      <div
        className="box"
        style={{
          height: BOX_HEIGHT,
          width: BOX_WIDTH
        }}
      >
        <div className="bottom-right-div"></div>
        <div
          className={`inner-box ${direction}`}
          style={{
            height: INNER_BOX_SIZE,
            width: INNER_BOX_SIZE,
            backgroundImage: `url(${getImage()})`,
            top: innerBoxPosition.top,
            left: innerBoxPosition.left,
            backgroundPosition: "0 -10px"
          }}
        ></div>
        <div
          className="obstacle"
          style={{
            height: OBSTACLE_HEIGHT,
            width: OBSTACLE_WIDTH
          }}
        ></div>
        <div
          className="board"
          style={{
            height: BOARD_HEIGHT,
            width: BOARD_WIDTH
          }}
        ></div>

        {showDEXText && (
          <div className="textBox">
            <div className="typedOutWrapper">
              <div className="typedOut">
                Hello, would you like to access our DEX?
              </div>{" "}
            </div>
            <div className="textSelect" onClick={() => showDexFunc(true)}>
              {" "}
              Okay{" "}
            </div>
            <div className="textSelect2" onClick={() => setShowDEXText(false)}>
              {" "}
              No thanks{" "}
            </div>
          </div>
        )}
        {showBoardText && (
          <div className="textBox">
            <div className="typedOutWrapper">
              <div className="typedOut">Examine the sticky note board?</div>{" "}
            </div>
            <div className="textSelect" onClick={() => showBoardFunc(true)}>
              {" "}
              Okay{" "}
            </div>
            <div
              className="textSelect2"
              onClick={() => setShowBoardText(false)}
            >
              {" "}
              No thanks{" "}
            </div>
          </div>
        )}

        {nekoText && (
          <div className="textBox">
            <div className="typedOutWrapper">
              <div className="typedOut"> Examine the neko cat?</div>{" "}
            </div>
            <div className="textSelect" onClick={() => Neko()}>
              {" "}
              Okay{" "}
            </div>
            <div className="textSelect2" onClick={() => setNekoText(false)}>
              {" "}
              No thanks{" "}
            </div>{" "}
          </div>
        )}
        {showNeko && (
          <div className="textBoxNeko">
            <div className="typedOutWrapper">
              <div className="typedOut">"Welcome to the Neko DEX Cafe!" </div>

              <div className="textSelect2" onClick={() => setShowNeko(false)}>
                {" "}
                Done{" "}
              </div>
            </div>
          </div>
        )}

        <div className="table1" />

        <div className="table2" />
      </div>

      {showDEX && (
        <div className="modal">
          <div className="modal-content">
            <>
              <SwapPoolView />
            </>
            <button onClick={() => setShowDEX(false)}>Close</button>
          </div>
        </div>
      )}
      {showBoard && (
        <>
          <button style={{ zIndex: 11 }} onClick={() => setShowBoard(false)}>
            Close
          </button>
          <StickyBoard />
        </>
      )}

      {showNeko && (
        <div className="modal">
          <img
            className="nekoBig"
            src="https://66.media.tumblr.com/tumblr_ma11pbpN0j1rfjowdo1_500.gif"
          />
        </div>
      )}

      <img
        className="neko"
        src="https://66.media.tumblr.com/tumblr_ma11pbpN0j1rfjowdo1_500.gif"
      />

      <img className="worker" src={worker} />
    </div>
  );
}
