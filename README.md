# 🔔 Desti_Bell

**Desti_Bell** est un script FiveM de notification conçu pour alerter automatiquement les administrateurs lorsqu'un joueur rejoint un channel vocal.

---

## ✨ Fonctionnalités

- 📢 **Notification instantanée** dès qu'un joueur entre dans un salon vocal
- 👮 **Système dédié aux administrateurs / modérateurs** (via les groupes ACE)
- 💬 **Notification Discord** via webhook avec embed personnalisé
- 🗨️ **Notification en jeu** dans le chat pour les admins connectés
- 📍 Affichage optionnel des **coordonnées** du joueur
- 🪪 Affichage optionnel des **identifiants** (Steam, Discord…)
- 🛡️ **Anti-spam** avec cooldown configurable
- ⚡ Léger, rapide et facile à intégrer
- 🔧 Compatible **pma-voice**, **mumble-voip** et toute ressource via export

---

## 📁 Structure

```
Desti_Bell/
├── fxmanifest.lua   # Manifest FiveM
├── config.lua       # Configuration
├── server.lua       # Logique serveur (webhook, notifications admins)
└── client.lua       # Logique client (détection channel vocal)
```

---

## 🚀 Installation

1. Téléchargez ou clonez ce dépôt dans votre dossier `resources` :
   ```bash
   git clone https://github.com/Spycke544/Desti_Bell [dossier resources]/Desti_Bell
   ```
2. Ajoutez la ressource dans votre `server.cfg` :
   ```
   ensure Desti_Bell
   ```
3. Configurez le fichier `config.lua` (voir section ci-dessous).

---

## ⚙️ Configuration (`config.lua`)

| Variable | Type | Description |
|---|---|---|
| `Config.WebhookURL` | `string` | URL du webhook Discord (laisser vide pour désactiver) |
| `Config.WebhookUsername` | `string` | Nom affiché par le bot Discord |
| `Config.WebhookColor` | `number` | Couleur de l'embed Discord (valeur décimale) |
| `Config.InGameNotification` | `boolean` | Activer les notifications en jeu |
| `Config.AdminGroups` | `table` | Liste des groupes ACE considérés comme admins |
| `Config.ChatPrefix` | `string` | Préfixe affiché dans le chat en jeu |
| `Config.CooldownSeconds` | `number` | Délai anti-spam entre deux notifications pour le même joueur (0 = désactivé) |
| `Config.ShowCoords` | `boolean` | Afficher les coordonnées dans le webhook Discord |
| `Config.ShowIdentifiers` | `boolean` | Afficher les identifiants Steam/Discord dans le webhook |

### Exemple minimal

```lua
Config.WebhookURL = "https://discord.com/api/webhooks/XXXX/YYYY"
Config.AdminGroups = { "group.admin", "group.mod" }
```

---

## 🔌 Intégration avec votre ressource vocale

### pma-voice / mumble-voip (automatique)

Le script écoute automatiquement les événements `pma-voice:setVoiceChannel` et `mumble-voip:channelChanged`. Aucune configuration supplémentaire n'est requise.

### Intégration manuelle via export

Depuis n'importe quelle autre ressource (client-side) :

```lua
exports["Desti_Bell"]:joinVoiceChannel("Staff Channel")
```

---

## 🔐 Permissions ACE

Assurez-vous que vos groupes admin disposent des permissions ACE dans `server.cfg` :

```
add_principal identifier.steam:XXXXXXXXXXXXXXXX group.admin
```

---

## 📜 Licence

MIT — libre d'utilisation et de modification.
