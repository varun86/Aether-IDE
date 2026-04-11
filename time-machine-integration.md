# Intégration native Time‑Machine (3 étapes)

Développé par **Barack Ndenga** — adapté ici en version **native Tauri** pour Aether IDE.

## Étape 1 — Backend IDE (serveur)

Dans Aether IDE, le serveur WebSocket est **natif en Rust** et démarre automatiquement en mode Tauri (port `7878`).

Si tu veux le démarrer manuellement :

```ts
import { IDEBridge } from "../src/lib/ide-bridge";

new IDEBridge({ wsPort: 7878 }).init({ maxSaves: 5 });
```

## Étape 2 — App utilisateur (injectée)

Dans une app instrumentée (browser/Node), tu peux utiliser le même bridge pour streamer les changements vers l’IDE :

```js
const { IDEBridge } = require("./ide-bridge");

const bridge = new IDEBridge({ wsPort: 7878 });
bridge.init({ maxSaves: 5 });
bridge.getCore().start();
```

## Étape 3 — WebView IDE (UI)

Dans une WebView/panel, tu peux écouter `postMessage` :

```js
window.addEventListener("message", (e) => {
  const msg = e.data;
  if (msg?.type === "VARIABLE_CHANGE") {
    console.log("change", msg.payload);
  }
});
```

## Stockage disque (Tauri)

Les snapshots sont stockés dans `$APPDATA/aether-ide/time-machine.snapshots.json` via `@tauri-apps/plugin-fs`.

