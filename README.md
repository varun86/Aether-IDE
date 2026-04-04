# ✨ Aether IDE

Un éditeur de code **léger**, **performant** et **cross-platform** construit avec **Tauri**, **React** et **Rust**.

![Tauri](https://img.shields.io/badge/Tauri-FFC131?style=flat-square&logo=tauri&logoColor=white)
![React](https://img.shields.io/badge/React-61DAFB?style=flat-square&logo=react&logoColor=black)
![Rust](https://img.shields.io/badge/Rust-CE422B?style=flat-square&logo=rust&logoColor=white)
![License](https://img.shields.io/badge/License-Apache%202.0-blue?style=flat-square)

## 🎯 Fonctionnalités Principales

- ⚡ **Performance extrême** - Alimenté par Rust pour une vitesse d'exécution optimale
- 🎨 **Éditeur Monaco** - Le même éditeur que VS Code, avec support complet de la syntaxe
- 📁 **Gestion native des fichiers** - Accès au système de fichiers avec dialogues natifs
- 🖥️ **Cross-platform** - Windows, macOS (Intel & Apple Silicon), Linux
- 🔧 **Intégrations système** - Dialogues natifs, notifications, et plus
- 💻 **Interface moderne** - UI intuitive construite avec React
- 🌙 **Mode sombre/clair** - Thèmes adaptés à votre préférence

## 📋 Prérequis

### Système
- **Node.js** 18+ (recommandé 20+)
- **Rust** (installé via [rustup](https://rustup.rs/))
- **npm**, **yarn** ou **pnpm**

### Dépendances Linux
```bash
sudo apt-get install libgtk-3-dev libwebkit2gtk-4.1-dev libappindicator3-dev librsvg2-dev patchelf

macOS

Xcode Command Line Tools
Windows

Visual Studio 2022 (ou Build Tools)

# 1. Cloner le repository
git clone https://github.com/BarackNdenga/Aether-IDE.git
cd Aether-IDE

# 2. Installer les dépendances
npm install

# 3. Lancer l'IDE en mode développement
npm run tauri dev

# 4. Construire pour la production
npm run tauri build


🛠️ Commandes Disponibles

Commande	Description
npm run tauri dev	Lance l'IDE en mode développement avec hot reload
npm run tauri build	Compile l'application pour votre plateforme
npm run tauri info	Affiche les informations de configuration Tauri
npm run lint	Vérifie la qualité du code


📦 Stack Technique

Composant	Technologie
Frontend	React 18+
Éditeur de code	Monaco Editor (VS Code)
Framework Desktop	Tauri
Runtime	Rust
Empaquetage	Tauri Bundle


🔄 Processus de Release

Les releases sont automatisées via GitHub Actions. Créez simplement un tag :

git tag v1.0.0
git push origin v1.0.0


Le workflow .github/workflows/release.yml :

✅ Crée automatiquement une GitHub Release
✅ Compile pour Windows (.msi, .exe)
✅ Compile pour Ubuntu (.deb, AppImage)
✅ Compile pour macOS (Intel + Apple Silicon)
✅ Attache les artefacts à la release



📁 Structure du Projet

Code
Aether-IDE/
├── src/                    # Code React frontend
├── src-tauri/             # Code Rust backend
│   ├── src/               # Logique Rust
│   └── tauri.conf.json    # Configuration Tauri
├── .github/workflows/     # GitHub Actions
├── package.json           # Dépendances frontend
└── README.md             # Ce fichier



🤝 Contribution

Les contributions sont les bienvenues ! N'hésitez pas à :

Fork le repository
Créer une branche (git checkout -b feature/amazing-feature)
Commit vos changements (git commit -m 'Add amazing feature')
Push vers la branche (git push origin feature/amazing-feature)
Ouvrir une Pull Request


📝 License

Ce projet est licencié sous la Apache License 2.0.

💬 Support

Vous avez des questions ou besoin d'aide ?

📖 Consultez la documentation Tauri
🐛 Ouvrez une issue
💬 Commencez une discussion

