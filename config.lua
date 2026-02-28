-- ============================================================
--  desti_bell — Configuration
-- ============================================================

Config = {}

-- URL du webhook Discord où les alertes seront envoyées.
-- Remplacez la valeur ci-dessous par l'URL de votre propre webhook.
Config.WebhookURL = 'https://discord.com/api/webhooks/VOTRE_WEBHOOK_ICI'

-- Nom affiché comme auteur du message embed Discord.
Config.BotName = 'Desti Bell'

-- URL de l'avatar du bot affiché dans l'embed (peut rester vide).
Config.BotAvatar = ''

-- Couleur de la barre latérale de l'embed Discord (valeur décimale).
-- 3066993 = vert, 15158332 = rouge, 16776960 = jaune
Config.EmbedColor = 3066993

-- Nom du salon vocal d'attente tel qu'il est affiché en jeu / dans les logs.
-- Utilisé uniquement à titre informatif dans le message envoyé.
Config.VoiceChannelName = 'Salle d\'attente'

-- Activer les logs serveur dans la console FiveM (true / false).
Config.EnableConsoleLogs = true

-- Délai anti-spam (en millisecondes) entre deux notifications pour le même joueur.
-- Empêche les spams si un joueur entre/sort rapidement du salon.
Config.CooldownMs = 30000
