import React, { useState, useEffect } from "react";
import "./styles.css";

export default function StickyNotes() {
  return (
    <div className="modal">
      <div className="modal-content">
        <div className="note">
          0x..2FAB <br />
          $100
          <br />
          Have a good day!
        </div>
      </div>
    </div>
  );
}
