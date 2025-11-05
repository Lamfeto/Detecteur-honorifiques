# Detecteur-honorifiques
Détecte et marque les honorifiques japonais dans le champ 'Effect' avec sauvegarde et restauration

Nouvelles fonctionnalités ajoutées :

1. 🔍 Détection avancée des honorifiques

 - Le script détecte désormais les mots isolés (par espaces, ponctuation, etc.) pour éviter les faux positifs comme “tôt ou tard”.
 - Peut aussi, selon une option, autoriser les formes liées par un tiret (ex. Mitsuru-sempai).

2. 🪟 Boîte de configuration interactive
 - Une fenêtre s’ouvre lorsque l’on clique sur le script, avec :
  - Une case à cocher :
    ✅ Autoriser les honorifiques liés par un tiret
  - Un champ pour ajouter ou modifier la liste d’honorifiques.
  - texte d’exemple listant les honorifiques par défaut :
    san, kun, chan, sama, senpai, sempai, sensei, dono, tan, shi, hime, ou, bei, pai, sen, nyan, chi, samā, senpāi, ō, hīmē, shī, dōno

3. 💾 Sauvegarde persistante
 - Lorsqu’un utilisateur ajoute un mot, le script l’enregistre dans un fichier (honorifiques_config.txt) placé dans le dossier Aegisub.
 - À la prochaine ouverture, la liste personnalisée est automatiquement rechargée.

4. 🧠 Indication précise
 - Le champ Effect affiche maintenant le mot exact détecté :
                  Honorifique détecté : sama
 - Cela aide à savoir immédiatement quel terme a déclenché la détection.

5. 🧹 Suppression améliorée des balises ASS
 - Le script nettoie le texte des balises de style {...} avant l’analyse, pour éviter les détections erronées sur du code de formatage.

6. ⚙️ Configuration évolutive
- Le comportement du script peut être ajusté sans modifier le code source :
   - Activation/désactivation de la recherche avec tiret.
   - Édition de la liste de détection directement depuis l’interface.

   | Fonctionnalité                         | Version 1.3 | Nouvelle version                |
| -------------------------------------- | ------------- | -------------------------------- |
| Détection par tiret uniquement         | ✅ Oui       | ✅ Optionnelle                   |
| Détection de mots isolés               | ❌ Non       | ✅ Oui                           |
| Liste d’honorifiques fixe              | ✅ Oui       | ❌ Non (modifiable)              |
| Interface graphique                    | ❌ Non       | ✅ Oui                           |
| Sauvegarde de configuration            | ❌ Non       | ✅ Oui                           |
| Précision du mot détecté               | ❌ Non       | ✅ Oui                           |
| Nettoyage des balises ASS              | ✅ Oui       | ✅ Oui (amélioré)                |
| Personnalisation sans modifier le code | ❌ Non       | ✅ Oui                           |
| Fichier de configuration externe       | ❌ Non       | ✅ Oui (honorifiques_config.txt) |
| -------------------------------------- | ------------  | -------------------------------- |
