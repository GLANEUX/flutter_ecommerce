# TP - Application E-Commerce Complète

# Infos rapides

- **Durée :** 5 jours (binômes)
- **Objectif :** livrer un MVP e‑commerce **fonctionnel**, **architecturé (MVVM/Clean)**, **authentifié**, **industrialisé (CI)** et **déployé** (Web obligatoire, Android si possible).
- **Livrables :** Code source, artefacts CI, URL déployée.

---

## Portée (MVP réaliste sur 5 jours)

**ShopFlutter** doit permettre de :

- Parcourir un **catalogue** (liste + recherche/filtre simple)
- Voir un **détail produit** (images, prix, description)
- **Ajouter au panier**, modifier quantités, **total**
- **Checkout** simplifié (mock paiement) + **création d’une commande** (persistée localement)
- **Auth Email/Password (Firebase Auth)**
- **Optionnel recommandé** (si temps) : **Historique des commandes** et page **Profil**

---

## Navigation

- **`go_router`** avec routes : `/catalog`, `/login`, `/home`, `/product/:id`, `/cart`, `/checkout`, `/orders` (optionnel)
- **Guard d’auth** (redirige vers `/login` si non authentifié)

---

## Données

- Source **au choix** :
  - **API mock** locale (JSON embarqué) **ou**
  - API publique type _Fake Store_ (si réseau OK)
- Modèle minimal `Product{id,title,price,thumbnail,images[],description,category}`
- Repository Catalog : `fetchProducts()`, `fetchProduct(id)`
- **Cache local** pour la liste **ou** les détails (recommandé)

---

## Code spécifique plateformes (au moins 1 exigence)

Implémentez **≥ 1 adaptation** parmi :

- **Web** : PWA manifest + bouton « Installer » **ou** Web Share
- **iOS** : page Détail en `CupertinoPageScaffold` **ou** FaceID pour ré‑ouvrir l’app (si device)
- **Android** : _Share intent_ (via `share_plus`) **ou** icône Adaptive / back gesture personnalisé

> Code conditionnel (kIsWeb, Platform.isAndroid, Platform.isIOS). Platform Channels = bonus.

---

## Authentification (obligatoire)

- **Firebase Auth – Email/Password**
- Écrans : Login/Register + Logout, gestion d’erreurs
- Guard basé sur `authStateChanges()`
- Stockage sécurisé (`flutter_secure_storage`) **optionnel**
- **Google Sign‑In** = **bonus**

---

## CI/CD & Déploiement

**CI (GitHub Actions) – requis** :

- `flutter format --set-exit-if-changed` + `flutter analyze`
- `flutter test --coverage` (≥ **50 %**)
- Build **Web** (artefact `build/web`)

**Déploiement (obligatoire)** :

- **Web** sur Firebase Hosting **ou** GitHub Pages (URL dans README)

**Android (recommandé)** :

- Build **AAB/APK** (upload artefact). Internal testing Play si compte dispo.

---

## Tests (minimum)

- **5 tests unitaires** (use cases / viewmodels)
- **2 tests widget** (ex : ProductCard, ProductList)
- Rapport de **couverture ≥ 50 %** dans artefacts CI
