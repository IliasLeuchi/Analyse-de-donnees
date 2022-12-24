######################################################################
#AFDM - Analyse Factorielle des Données Mixtes avec R
######################################################################


#L’Analyse Factorielle des Données Mixtes (AFDM ou FAMD pour Factor Analysis of Mixed Data en anglais) est une méthode destinée à analyser un jeu de données contenant à la fois des variables quantitatives et qualitatives (Pagès 2004). Elle permet d’analyser la similitude entre les individus en prenant en compte des variables mixtes. De plus, on peut explorer l’association entre toutes les variables, tant quantitatives que qualitatives.

#Pour faire simple, l’algorithme AFDM peut être considéré comme mixte entre l’analyse en composantes principales (ACP) et l’analyse des correspondances multiples (ACM). En d’autres termes, il agit comme l’ACP concernant les variables quantitatives et comme l’ACM concernant les variables qualitatives.

#Les variables quantitatives et qualitatives sont normalisées au cours de l’analyse afin d’équilibrer l’influence de chaque ensemble de variables.

#Dans le chapitre actuel, nous décrivons comment calculer et visualiser l’analyse factorielle des données mixtes en utilisant les packages FactoMineR (pour l’analyse) et factoextra (pour la visualisation des données).

#Contents:

#    Calcul
#        Packages R
#        Format des données
#        code R
#    Visualisation et interprétation
#        Valeurs propres / Variances
#        Graphique des variables
#        Graphique des individus
#    Résumé
#    References


#Installation:

install.packages(c("FactoMineR", "factoextra"))

#Chargez les packages:

library("FactoMineR")
library("factoextra")

#Format des données : nous utiliserons le jeu de données wine dans le package FactoMineR:

library("FactoMineR")
data(wine)
df <- wine[,c(1,2, 16, 22, 29, 28, 30,31)]
head(df[, 1:7], 4)

##           Label Soil Plante Acidity Harmony Intensity Overall.quality
## 2EL      Saumur Env1   2.00    2.11    3.14      2.86            3.39
## 1CHA     Saumur Env1   2.00    2.11    2.96      2.89            3.21
## 1FON Bourgueuil Env1   1.75    2.18    3.14      3.07            3.54
## 1VAU     Chinon Env2   2.30    3.18    2.04      2.46            2.46

#Pour voir la structure des données, tapez ceci:

str(df)

#Les données contiennent 21 lignes (individus) et 8 colonnes (variables): les deux premières colonnes sont des variables catégorielles: label (Saumur, Bourgueil ou Chinon) et soil (Reference, Env1, Env2 or Env4). Les colonnes restantes sont numériques (variables continues).

#L’objectif de cette étude est d’analyser les caractéristiques des vins. Pour ceic, la fonction FAMD() [package FactoMineR] peut être utilisée pour le calcul. Un format simplifié est:

#FAMD (base, ncp = 5, sup.var = NULL, ind = NULL, graph = TRUE)

#    base: un data frame avec n lignes (individus) et p colonnes (variables).
#    ncp: le nombre de dimensions conservées dans les résultats (par défaut 5)
#    sup.var: un vecteur indiquant les positions des variables supplémentaires.
#    ind: un vecteur indiquant les positions des individus supplémentaires.
#    graphique: une valeur logique. Si TRUE le graphique est affiché.

#Pour calculer l’AFDM, tapez ceci:

library(FactoMineR)
res.famd <- FAMD(df, graph = FALSE)

#Le résultat de la fonction FAMD() est une liste comprenant:

print(res.famd)

## *The results are available in the following objects:
## 
##   name          description                             
## 1 "$eig"        "eigenvalues and inertia"               
## 2 "$var"        "Results for the variables"             
## 3 "$ind"        "results for the individuals"           
## 4 "$quali.var"  "Results for the qualitative variables" 
## 5 "$quanti.var" "Results for the quantitative variables"

#Visualisation et interprétation : nous utiliserons les fonctions suivantes du package factoextra:

    #get_eigenvalue(res.famd): Extraction des valeurs propres / variances des composantes principales.
    #fviz_eig(res.famd): Visualisation des valeurs propres.
    #get_famd_ind(res.famd): Extraction des résultats pour les individus.
    #get_famd_var(res.famd): Extraction des résultats pour les variables quantitatives et qualitatives.
    #fviz_famd_ind (res.famd), fviz_famd_var(res.famd): Visualisation des résultats pour les individus et les variables, respectivement.

#Dans les sections suivantes, nous allons illustrer chacune de ces fonctions. Pour aider à l’interprétation de l’AFDM, nous recommandons fortement de lire l’interprétation de l’analyse en composantes principales et de l’analyse des correspondances multiples. Beaucoup de graphiques présentés ici ont déjà été décrits dans nos chapitres précédents.

#Valeurs propres / Variances : la proportion de variances expliquées par les différentes dimensions (axes) peut être extraite à l’aide de la fonction get_eigenvalue() [factoextra] comme suit:

library("factoextra")
eig.val <- get_eigenvalue(res.famd)
head(eig.val)

##       eigenvalue variance.percent cumulative.variance.percent
## Dim.1      4.832            43.92                        43.9
## Dim.2      1.857            16.88                        60.8
## Dim.3      1.582            14.39                        75.2
## Dim.4      1.149            10.45                        85.6
## Dim.5      0.652             5.93                        91.6

#La fonction fviz_eig() ou fviz_screeplot() [factoextra] peut être utilisée pour visualiser les proportions de variances expliquées par les différents axes:

fviz_screeplot(res.famd)

#Graphique des variables : toutes les variables

#La fonction get_mfa_var() [factoextra] est utilisée pour extraire les résultats pour les variables. Par défaut, cette fonction renvoie une liste contenant les coordonnées, les cos2 (cosinus carré) et les contribution de toutes les variables:

var <- get_famd_var (res.famd)
var

## FAMD results for variables 
##  ===================================================
##   Name       Description                      
## 1 "$coord"   "Coordinates"                    
## 2 "$cos2"    "Cos2, quality of representation"
## 3 "$contrib" "Contributions"

#Les différents composants peuvent être consultés comme suit:

# Coordonnées des variables
head(var$coord)
# Cos2: qualité de représentation
head(var$cos2)
# Contributions aux dimensions
head(var$contrib)

#La figure suivante montre la corrélation entre les variables - variables quantitatives et qualitatives - et les axes principaux, ainsi que la contribution des variables aux axes 1 et 2. Les fonctions suivantes [dans le package factoextra] sont utilisées:

    #fviz_famd_var() pour visualiser les variables quantitatives et qualitatives
    #fviz_contrib() pour visualiser la contribution des variables aux axes principaux

# Graphique des variables
fviz_famd_var (res.famd, repel = TRUE)
# Contribution à la première dimension
fviz_contrib (res.famd, "var", axes = 1)
# Contribution à la deuxième dimension
fviz_contrib (res.famd, "var", axes = 2)

#La ligne en pointillé rouge sur le graphique ci-dessus indique la valeur moyenne attendue, si les contributions étaient uniformes. 

#A partir des graphiques ci-dessus, on constate que:
    #Les variables qui contribuent le plus à la première dimension sont: Overall.quality et Harmony.
    #les variables qui contribuent le plus à la deuxième dimension sont: Soil et Acidity.

#Variables quantitativesc: pour extraire les résultats pour les variables quantitatives, tapez ceci:

quanti.var <- get_famd_var(res.famd, "quanti.var")
quanti.var 

## FAMD results for quantitative variables 
##  ===================================================
##   Name       Description                      
## 1 "$coord"   "Coordinates"                    
## 2 "$cos2"    "Cos2, quality of representation"
## 3 "$contrib" "Contributions"

#Dans cette section, nous décrirons comment visualiser les variables quantitatives. De plus, nous allons montrer comment mettre en évidence les variables selon i) leurs qualités de représentation ou ii) leurs contributions aux dimensions.

#Le code R ci-dessous présente les variables quantitatives. Nous utilisons repel = TRUE, pour éviter le chevauchement de texte.

fviz_famd_var(res.famd, "quanti.var", repel = TRUE, col.var = "black")

#En bref, le graphique des variables (cercle de corrélation) montre le lien entre les variables, la qualité de la représentation des variables, ainsi que la corrélation entre les variables et les dimensions.

#Les variables quantitatives les plus contributives peuvent être mises en évidence sur le graphique en utilisant l’argument col.var = “contrib”. Cela produit un gradient de couleurs, qui peut être personnalisé à l’aide de l’argument gradient.cols.

fviz_famd_var(res.famd, "quanti.var", col.var = "contrib", 
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE)

#De même, vous pouvez mettre en évidence des variables quantitatives en utilisant leurs cos2 représentant la qualité de représentation. Si une variable est bien représentée par deux dimensions, la somme des cos2 est proche de 1. Pour certains des éléments, plus de 2 dimensions pourraient être nécessaires pour représenter parfaitement les données.

# Couleur par valeurs cos2: qualité sur le plan des facteurs
fviz_famd_var(res.famd, "quanti.var", col.var = "cos2",
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"), 
             repel = TRUE)

#Graphique des variables qualitatives : comme les variables quantitatives, les résultats pour les variables qualitatives peuvent être extraits comme suit:

quali.var <- get_famd_var(res.famd, "quali.var")
quali.var 

## FAMD results for qualitative variable categories 
##  ===================================================
##   Name       Description                      
## 1 "$coord"   "Coordinates"                    
## 2 "$cos2"    "Cos2, quality of representation"
## 3 "$contrib" "Contributions"

#Pour visualiser les variables qualitatives, tapez ceci:

fviz_famd_var(res.famd, "quali.var", col.var = "contrib", 
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07")
             )

#Le graphique ci-dessus montre les catégories des variables catégorielles.

#Graphique des individus : pour obtenir les résultats pour les individus, tapez ceci:

ind <- get_famd_ind(res.famd)
ind

## FAMD results for individuals 
##  ===================================================
##   Name       Description                      
## 1 "$coord"   "Coordinates"                    
## 2 "$cos2"    "Cos2, quality of representation"
## 3 "$contrib" "Contributions"

#Pour visualiser les individus, utilisez la fonction fviz_famd_ind() [factoextra]. Par défaut, les individus sont colorés en bleu. Cependant, comme des variables, il est également possible de colorer les individus par leurs cos2 et leurs valeurs de contribution:

fviz_famd_ind(res.famd, col.ind = "cos2", 
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE)

#Dans le graphique ci-dessus, les catégories des variables qualitatives sont affichées en noir. Env1, Env2, Env3 sont les catégories de Soil. Saumur, Bourgueuil et Chinon sont les catégories de la variable Label. Si vous ne souhaitez pas les afficher sur le graphique, utilisez l’argument invisible = "quali.var".

#Les individus ayant des profils similaires sont proches dans le graphique. Notez qu’il est possible de colorer les individus en utilisant l’une des variables qualitatives dans le tableau de données initial. Pour ce faire, l’argument habillage est utilisé dans la fonction fviz_famd_ind(). Par exemple, si vous souhaitez colorer les vins selon la variable qualitative supplémentaire “Label”, tapez ceci:

fviz_mfa_ind(res.famd, 
             habillage = "Label", # color by groups 
             palette = c("#00AFBB", "#E7B800", "#FC4E07"),
             addEllipses = TRUE, ellipse.type = "confidence", 
             repel = TRUE # Avoid text overlapping
             ) 

#Si vous souhaitez colorer les individus à l’aide de plusieurs variables catégorielles en même temps, utilisez la fonction fviz_ellipses() [factoextra] comme suit:

fviz_ellipses(res.famd, c("Label", "Soil"), repel = TRUE)

#Alternativement, vous pouvez spécifier les positions des variables catégorielles:

fviz_ellipses(res.famd, 1:2, geom = "point")

#Résumé
#L’analyse factorielle des données mixtes (AFDM) permet d’analyser un jeu de données, dans lequel les individus sont décrits à la fois par des variables qualitatives et quantitatives. Dans ce chapitre, nous avons décrit comment calculer et interpréter l’AFDM en utilisant les packages R FactoMineR et factoextra.
