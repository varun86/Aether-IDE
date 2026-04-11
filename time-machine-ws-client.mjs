import WebSocket from "ws";

const url = process.env.TM_WS_URL || "ws://127.0.0.1:7878";

function send(ws, type, payload = {}) {
  ws.send(JSON.stringify({ type, payload }));
}

console.log(`[tm] connecting to ${url} …`);

const ws = new WebSocket(url);

ws.on("open", () => {
  console.log("[tm] connected");
  send(ws, "GET_SAVES");

  // Démo: démarrer/arrêter l’enregistrement
  if (process.env.TM_DEMO === "1") {
    send(ws, "START_RECORDING");
    setTimeout(() => send(ws, "STOP_RECORDING"), 1500);
  }
});

ws.on("message", (data) => {
  try {
    const msg = JSON.parse(data.toString());
    const t = msg?.type || "UNKNOWN";
    console.log(`[tm] ${t}`, msg?.payload ?? "");
  } catch {
    console.log("[tm] message", data.toString());
  }
});

ws.on("close", () => {
  console.log("[tm] disconnected");
  process.exit(0);
});

ws.on("error", (err) => {
  console.error("[tm] error:", err.message);
  process.exit(1);
});

