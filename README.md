# تسيير الميزانية المنزلية — mise en ligne sécurisée

Contenu : `index.html`, `config.js`, `manifest.json`, `sw.js`, `icons/`, `supabase_setup.sql`.

## 1. Créer le projet Supabase (gratuit)
1. https://supabase.com → **New project** (choisissez un mot de passe de base de données solide).
2. **SQL Editor → New query** : collez le contenu de `supabase_setup.sql` → **Run**.
3. **Project Settings → API** : copiez **Project URL** et la clé **anon / publishable** dans `config.js`.
   Ne mettez jamais la clé `service_role` dans l'application.

## 2. Réglages d'authentification (Authentication)
- **Providers → Email** : activé, « Confirm email » activé. **Minimum password length : 8 ou plus.**
- **URL Configuration** :
  - Site URL : `https://VOTRE-COMPTE.github.io/NOM-DU-DEPOT/`
  - Redirect URLs : `https://VOTRE-COMPTE.github.io/NOM-DU-DEPOT/**`
- (Recommandé) activer la protection CAPTCHA et, si votre offre le permet, la protection contre les mots de passe compromis.

## 3. Connexion avec Google
1. https://console.cloud.google.com → créez un projet → **APIs & Services → OAuth consent screen** (External, nom de l'app, votre e-mail).
2. **Credentials → Create credentials → OAuth client ID → Web application**.
   - Authorized redirect URI : `https://<ref-projet>.supabase.co/auth/v1/callback`
     (affiché dans Supabase → Authentication → Providers → Google).
3. Copiez **Client ID** et **Client secret** dans Supabase → **Providers → Google** → activer → Save.

## 4. Publier sur GitHub Pages
1. Créez un dépôt GitHub, déposez tous les fichiers de ce dossier à la racine.
2. **Settings → Pages → Deploy from a branch → main / (root)**.
3. Ouvrez `https://VOTRE-COMPTE.github.io/NOM-DU-DEPOT/` : créez un compte, puis installez l'application (menu du navigateur).

## Ce qui protège l'application
- Chaque utilisateur ne lit et n'écrit que **sa propre ligne** (Row Level Security) ; aucun accès pour les visiteurs non connectés.
- Mots de passe gérés par Supabase (hachés, jamais stockés dans l'application) ; messages de connexion génériques ; réinitialisation par e-mail.
- Connexion Google en flux PKCE ; déconnexion locale ; cache local supprimé à la déconnexion.
- Politique de sécurité du contenu (CSP) limitant les scripts et connexions autorisés ; données reçues du serveur nettoyées avant affichage.
- Limite de taille des données par utilisateur (300 Ko).
