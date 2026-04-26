# HelixAI

**HelixAI** est une plateforme d'IA ultra-performante, auto-hebergee, conçue pour exploiter pleinement vos modeles locaux via Ollama et les APIs compatibles OpenAI.

Fork customise d'Open WebUI, rebaptise et optimise pour la generation de code multi-agent et les deployments GPU.

---

## Fonctionnalites principales

- **Installation automatique d'Ollama** : Le script detecte et installe Ollama si absent
- **WebSocket persistant** : Plus de deconnexion quand vous quittez le dashboard ou changez d'onglet
- **Multi-modeles** : Support simultane de plusieurs modeles sur plusieurs GPUs
- **Reconnexion intelligente** : Reconnexion automatique instantanee sans toast intrusif
- **Interface rebranded** : Nouveau nom, nouveau logo, nouvelles couleurs — identite HelixAI
- **Ultra-leger** : Optimise pour la performance avec compression Brotli/Zstd integree
- **RAG integre** : 9 bases vectorielles, extraction de documents, recherche web
- **Code Interpreter** : Execution Python native dans le navigateur via Pyodide
- **PWA** : Experience app native sur mobile avec acces hors-ligne
- **RBAC** : Controle d'acces granulaire par roles et groupes

---

## Installation rapide

### Option 1 : Docker (recommandee)

```bash
# Clone le repo
git clone https://github.com/amavaljoh04-lang/helixai.git
cd helixai

# Lancement avec auto-install Ollama
bash run.sh
```

Accedez a HelixAI sur [http://localhost:3000](http://localhost:3000)

### Option 2 : Docker Compose

```bash
docker compose up -d
```

### Option 3 : Installation manuelle

```bash
# Installer Ollama si necessaire
bash scripts/install-ollama.sh

# Backend
cd backend
pip install -r requirements.txt
bash start.sh

# Frontend (dev)
npm ci
npm run dev
```

---

## Configuration GPU multi-serveurs

HelixAI supporte la repartition de charge sur plusieurs serveurs Ollama :

```env
OLLAMA_BASE_URLS=http://gpu1:11434;http://gpu2:11434;http://gpu3:11434
```

---

## Variables d'environnement cles

| Variable | Description | Defaut |
|---|---|---|
| `OLLAMA_BASE_URL` | URL du serveur Ollama | `http://localhost:11434` |
| `OLLAMA_BASE_URLS` | Plusieurs serveurs Ollama (separes par `;`) | - |
| `HELIXAI_DEFAULT_MODELS` | Modeles a telecharger automatiquement (separes par `,`) | - |
| `WEBUI_SECRET_KEY` | Cle secrete pour les sessions | auto-generee |
| `WEBSOCKET_SERVER_PING_TIMEOUT` | Timeout ping WebSocket (secondes) | `60` |
| `WEBSOCKET_SERVER_PING_INTERVAL` | Intervalle ping WebSocket (secondes) | `30` |

---

## Ce qui a change par rapport a Open WebUI

1. **Rebranding complet** : "Open WebUI" → "HelixAI" partout (frontend, backend, i18n, Docker)
2. **Logo et identite** : Nouveau logo double helice avec gradient cyan/violet/rose
3. **WebSocket resilient** : Reconnexion auto sur `visibilitychange`, pas de toast pour deconnexions transitoires, ping timeout augmente de 20s a 60s
4. **Auto-Ollama** : Script `scripts/install-ollama.sh` detecte, installe et demarre Ollama automatiquement
5. **Reconnexion rapide** : `reconnectionDelay` reduit de 1000ms a 500ms, tentatives infinies

---

## Licence

Meme licence que le projet original (MIT). Voir [LICENSE](./LICENSE).

---

**HelixAI** — L'intelligence artificielle, en local, sans compromis.
