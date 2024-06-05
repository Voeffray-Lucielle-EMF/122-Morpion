| **Test N** | **Description du test**      | **Resultat attendu** | **Contrôle**                                        |
|------------|------------------------------|----------------------|-----------------------------------------------------|
|            |                              |                      | ✅🟡🛑                                            |
|            | **Commentaire / Screenshot** | **Resultat obtenu**  | **Visa / Date**                                     |
|            |                              |                      | _[Nom de la personne responsable] / [Date du test]_ |

| **Test N** | **Description du test**      | **Resultat attendu** | **Contrôle**                                        |
|------------|------------------------------|----------------------|-----------------------------------------------------|
|            | Les logs sont bien écrites dans le document logs.log |Une ligne par entrée avec un type ([DEBUG] ou [INFO])| ✅                                            |
|     1      | **Commentaire / Screenshot** | **Resultat obtenu**  | **Visa / Date**                                     |
|            |  Tout bon | Une ligne par entrée avec un type ([DEBUG] ou [INFO])| Lucielle Voeffray, 05.06.2024 |

| **Test N** | **Description du test**      | **Resultat attendu** | **Contrôle**                                        |
|------------|------------------------------|----------------------|-----------------------------------------------------|
|            | Lancer le jeu avec deux pseudos différents et s'assurer que si on entre une case illégale le code boucle sur le joueur en question|Le contrôle de la case retourne boucle correctement sur le même joueur en cas d'entrée faussée | 🛑                                            |
|     2      | **Commentaire / Screenshot** | **Resultat obtenu**  | **Visa / Date**                                     |
|            | A DEBUGGUER RAPIDEMENT | Le jeu boucle sur le joueur suivant, pas le joueur qui a entré une mauvaise case| Lucielle Voeffray, 05.06.2024 |

| **Test N** | **Description du test**      | **Resultat attendu** | **Contrôle**                                        |
|------------|------------------------------|----------------------|-----------------------------------------------------|
|            | Lancer le jeu avec deux pseudos différents et s'assurer que si on entre une case illégale le code boucle sur le joueur en question|Le contrôle de la case retourne boucle correctement sur le même joueur en cas d'entrée faussée | ✅                                            |
|   2.1      | **Commentaire / Screenshot** | **Resultat obtenu**  | **Visa / Date**                                     |
|            | Problème d'incrémentaion de la variable $tour | Celui attendu| Lucielle Voeffray, 05.06.2024 |

| **Test N** | **Description du test**      | **Resultat attendu** | **Contrôle**                                        |
|------------|------------------------------|----------------------|-----------------------------------------------------|
|            |Le scoreboard écrit bien une nouvelle entrée pour un nouveau joueur gagnant: Avant de jouer, demander le scoreboard puis Jouer le jeu avec un pseudo jamais utilisé et gagner avec | Si on demande, après la partie, à voir le scoreboard, il devrait y avoir une entrée de plus | 🛑                                            |
|     3      | **Commentaire / Screenshot** | **Resultat obtenu**  | **Visa / Date**                                     |
|            | BUG A CORRIGER | C'est les attributs de l'objet $board qui étaient sauvés et non le scoreboard | Lucielle Voeffray, 05.06.2024 |

| **Test N** | **Description du test**      | **Resultat attendu** | **Contrôle**                                        |
|------------|------------------------------|----------------------|-----------------------------------------------------|
|            |Le scoreboard écrit bien une nouvelle entrée pour un nouveau joueur gagnant: Avant de jouer, demander le scoreboard puis Jouer le jeu avec un pseudo jamais utilisé et gagner avec | Si on demande, après la partie, à voir le scoreboard, il devrait y avoir une entrée de plus | ✅                                            |
|   3.1      | **Commentaire / Screenshot** | **Resultat obtenu**  | **Visa / Date**                                     |
|            | Il fallait pipe l'objet $board dans la commande Export-CSV et non pas utiliser -InputObject | Celui demandé | Lucielle Voeffray, 05.06.2024 |

| **Test N** | **Description du test**      | **Resultat attendu** | **Contrôle**                                        |
|------------|------------------------------|----------------------|-----------------------------------------------------|
|            | Entrer une case déjà occuppée | Répétition du tour du joueur qui a entré une mauvaise case | ✅                                            |
|     4      | **Commentaire / Screenshot** | **Resultat obtenu**  | **Visa / Date**                                     |
|            | Tout bon | Celui demandé | Lucielle Voeffray, 05.06.2024 |

| **Test N** | **Description du test**      | **Resultat attendu** | **Contrôle**                                        |
|------------|------------------------------|----------------------|-----------------------------------------------------|
|            | Lancer la fonction Scoreboard | La fonction affiche bien les score du plus élevé au moins élevé. Tout le monde a au moins un score de 1 | ✅                                            |
|     5      | **Commentaire / Screenshot** | **Resultat obtenu**  | **Visa / Date**                                     |
|            | Tout bon | Celui demandé | Lucielle Voefray, 05.06.2024 |

| **Test N** | **Description du test**      | **Resultat attendu** | **Contrôle**                                        |
|------------|------------------------------|----------------------|-----------------------------------------------------|
|            | Tester les différentes réussites | Pour chacune des réussites possible, la partie est terminée et repars sur la fonction WhatToDO | 🛑                                            |
|     6      | **Commentaire / Screenshot** | **Resultat obtenu**  | **Visa / Date**                                     |
|            | La diagonale montante n'est pas détectée comme gagnante | La diagonale montante n'est pas détectée comme gagnante | Lucielle Voefray, 05.06.2024 |

| **Test N** | **Description du test**      | **Resultat attendu** | **Contrôle**                                        |
|------------|------------------------------|----------------------|-----------------------------------------------------|
|            | Tester les différentes réussites | Pour chacune des réussites possible, la partie est terminée et repars sur la fonction WhatToDO | ✅                                            |
|   6.1      | **Commentaire / Screenshot** | **Resultat obtenu**  | **Visa / Date**                                     |
|            | Le contrôle de la réussite pour la diogonale montante contrôlait A3,B2,C3 au lieu de A3,B2,C1 | Le resultat attendu | Lucielle Voefray, 05.06.2024 |

| **Test N** | **Description du test**      | **Resultat attendu** | **Contrôle**                                        |
|------------|------------------------------|----------------------|-----------------------------------------------------|
|            | Tester une égalité           | Affichage de l'égalité | 🛑                                            |
|     7      | **Commentaire / Screenshot** | **Resultat obtenu**  | **Visa / Date**                                     |
|            |  | Le jeu veut continuer à faire jouer même s'il n'y a plus de possibilités | Lucielle Voefray, 05.06.2024 |

| **Test N** | **Description du test**      | **Resultat attendu** | **Contrôle**                                        |
|------------|------------------------------|----------------------|-----------------------------------------------------|
|            |  Tester une égalité          |  Affichage de l'égalité | ✅                                            |
|   7.1      | **Commentaire / Screenshot** | **Resultat obtenu**  | **Visa / Date**                                     |
|            | N'avait pas codé le cas de figure, maitenant il y a une fonction "CheckDraw" | Resultat attendu | Lucielle Voeffray, 05.06.2024 |