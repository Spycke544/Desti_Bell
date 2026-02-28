Config = {}

-- ============================================================
--  Discord
-- ============================================================
-- Mettez l'URL de votre webhook Discord ici.
-- Laissez vide ("") pour désactiver les notifications Discord.
Config.WebhookURL = ""

-- Nom affiché par le bot Discord
Config.WebhookUsername = "Desti Bell 🔔"

-- Couleur de l'embed Discord (valeur décimale)
-- 16776960 = jaune, 5763719 = vert, 15548997 = rouge
Config.WebhookColor = 16776960

-- ============================================================
--  Notifications en jeu
-- ============================================================
-- Envoyer une notification dans le chat en jeu aux joueurs admins
Config.InGameNotification = true

-- Groupe(s) considérés comme admins/modérateurs (ace permissions)
-- Exemple : "group.admin", "group.mod", "group.staff"
Config.AdminGroups = {
    "group.admin",
    "group.mod",
    "group.staff",
}

-- Préfixe affiché dans le chat en jeu
Config.ChatPrefix = "^3[🔔 Desti Bell]^0"

-- ============================================================
--  Comportement
-- ============================================================
-- Anti-spam : délai minimum (en secondes) entre deux notifications
-- pour le même joueur (0 = désactivé)
Config.CooldownSeconds = 30

-- Afficher les coordonnées du joueur dans la notification Discord
Config.ShowCoords = true

-- Afficher l'identifiant Steam / Discord du joueur dans la notification
Config.ShowIdentifiers = true
