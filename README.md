# 🔔 Desti_Bell

**desti_bell** est un script de notification pour serveurs **FiveM** qui alerte automatiquement les administrateurs (via Discord) lorsqu'un joueur rejoint un salon vocal d'attente.

---

## ✨ Fonctionnalités

- 📢 Notification instantanée dès qu'un joueur entre dans le salon vocal
- 👮 Système dédié aux administrateurs / modérateurs
- ⚡ Léger, rapide et facile à intégrer
- 🔧 Configuration simple et adaptable
- 🛡️ Anti-spam intégré (cooldown configurable par joueur)
- 🪝 Compatible avec les ressources vocales tierces (`pma-voice`, `mumble-voip`, etc.)

---

## 📂 Structure

```
desti_bell/
├── fxmanifest.lua   # Manifeste de la ressource FiveM
├── config.lua       # Configuration (webhook, couleur, cooldown…)
├── client.lua       # Côté client : détection de l'entrée dans le salon vocal
└── server.lua       # Côté serveur : envoi de l'alerte Discord
```

---

## 🚀 Installation

1. Copiez le dossier `desti_bell` dans le répertoire `resources` de votre serveur FiveM.
2. Ajoutez la ligne suivante dans votre `server.cfg` :
   ```
   ensure desti_bell
   ```
3. Configurez le fichier `config.lua` (voir ci-dessous).

---

## ⚙️ Configuration (`config.lua`)

| Paramètre             | Description                                                          | Valeur par défaut       |
|-----------------------|----------------------------------------------------------------------|-------------------------|
| `Config.WebhookURL`   | URL du webhook Discord où les alertes sont envoyées (**obligatoire**) | `'https://discord.com/api/webhooks/VOTRE_WEBHOOK_ICI'` |
| `Config.BotName`      | Nom affiché pour le bot dans Discord                                 | `'Desti Bell'`          |
| `Config.BotAvatar`    | URL de l'avatar du bot (optionnel)                                   | `''`                    |
| `Config.EmbedColor`   | Couleur de la barre de l'embed (valeur décimale)                     | `3066993` (vert)        |
| `Config.VoiceChannelName` | Nom du salon vocal affiché dans le message                       | `'Salle d\'attente'`    |
| `Config.EnableConsoleLogs` | Active les logs dans la console FiveM                           | `true`                  |
| `Config.CooldownMs`   | Délai anti-spam en ms entre deux alertes pour le même joueur         | `30000` (30 secondes)   |

---

## 🔗 Intégration avec une ressource vocale

### Depuis un autre script Lua (serveur ou client)

**Méthode 1 — Événements réseau (client → serveur automatique) :**
```lua
-- Depuis le client, déclenche la détection d'entrée dans le salon vocal
TriggerEvent('desti_bell:enterVoiceChannel')

-- Depuis le client, signale la sortie du salon vocal
TriggerEvent('desti_bell:leaveVoiceChannel')
```

**Méthode 2 — Exports client :**
```lua
exports['desti_bell']:EnterVoiceChannel()
exports['desti_bell']:LeaveVoiceChannel()
```

---

## 📌 Exemple d'intégration avec pma-voice

Dans votre ressource `pma-voice`, ajoutez dans le client :
```lua
AddEventHandler('pma-voice:setTalkingMode', function(mode)
    if mode == 'voiceChannel' then
        exports['desti_bell']:EnterVoiceChannel()
    else
        exports['desti_bell']:LeaveVoiceChannel()
    end
end)
```

---

## 🎯 Objectif

Permettre aux équipes d'administration de surveiller efficacement l'activité vocale et d'intervenir rapidement si nécessaire.

