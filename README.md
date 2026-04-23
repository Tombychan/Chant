# Chant — Parcours personnel de pédagogie vocale

Parcours structuré en quatre blocs pour acquérir une compréhension théorique croisée des approches de pédagogie vocale présentes dans Bozeman (PVA, KVP2), McCoy, Dayme & Besterman, et Henny.

Construit comme compagnon d'un travail vocal en présentiel avec une enseignante — ne remplace ni la pratique, ni l'enseignement.

## État actuel

**MVP Bloc 1 Semaine 1**, itération 1 : cadre technique complet, leçons 1 et 2 rédigées, leçons 3 à 6 en placeholder en attente de validation de l'ergonomie et du ton pédagogique.

## Blocs

1. **Fondations musicales minimales** — en cours
2. Anatomie et physiologie vocales — à venir
3. Acoustique de la voix — à venir
4. Pédagogie acoustique appliquée — à venir

## Stack technique

- HTML statique, React 18 via CDN (esm.sh), Tailwind CSS via CDN
- Pas de build step, pas de `npm install`
- Web Audio API pour la génération audio (sinusoïdes pures)
- `window.speechSynthesis` pour le TTS (voix natives Apple)
- Données en JSON versionnés dans `/data`
- `localStorage` utilisé comme cache de travail ; le repo reste la source de vérité

## Données

- `data/progression.json` — état d'avancement dans les leçons
- `data/journal.json` — journal de pratique
- `data/tessiture.json` — identification de la tessiture personnelle
- `data/vocabulaire_enseignante.json` — index des termes employés par l'enseignante

Chaque JSON inclut un champ `version` (SemVer) et un `changelog` intégré.

### Workflow de mise à jour des JSON

L'application utilise `localStorage` au fil de l'usage pour éviter la friction. Un bouton **Exporter** dans l'interface télécharge les 4 fichiers JSON à jour ; il suffit alors de les copier dans `/data/`, de commit et de push pour versionner la progression.

Recommandation : exporter une fois par semaine, ou avant tout changement de device.

## Développement local

```bash
# Depuis la racine du repo, lancer un serveur local (Python 3 préinstallé sur macOS) :
python3 -m http.server 8000

# Puis ouvrir http://localhost:8000
```

Un serveur local est nécessaire parce que les navigateurs refusent les requêtes `fetch()` vers des fichiers locaux ouverts directement avec `file://`.

## Déploiement

GitHub Pages sur la branche `main`, dossier racine. URL : `https://tombychan.github.io/chant/`.

## Philosophie

- **Pas de gamification** : ni streaks, ni badges, ni notifications. L'outil est pédagogique, pas motivationnel.
- **Honnêteté épistémique** : les simplifications sont signalées ; les divergences entre auteurs sont préservées ; les appariements et hypothèses indiquent leur niveau de confiance.
- **Calibrage personnel** : les exercices sont calibrés à la tessiture identifiée de l'utilisateur, non à une tessiture générique.
- **Ne remplace pas l'enseignante** : aucune prescription vocale sans signalement des limites ; journal dédié au vocabulaire de l'enseignante.

## Licence

Projet privé à usage personnel.
