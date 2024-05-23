-- 1/ Type du poste p8
SELECT TYPE_P 
FROM POSTE 
WHERE N_POSTE = 'p8';

-- 2/ Affichage du nom des postes qui sont de type UNIX ou PCWS
SELECT NOM_P 
FROM POSTE 
WHERE TYPE_P IN ('UNIX', 'PCWS');

-- 3/ Affichage du nom des postes qui ne sont pas de type UNIX ou PCWS
SELECT NOM_P 
FROM POSTE 
WHERE TYPE_P NOT IN ('UNIX', 'PCWS');

-- 4/ Noms des logiciels de type UNIX
SELECT NOM_L 
FROM LOGICIEL 
WHERE TYPE_L = 'UNIX';

-- 5/ Noms des logiciels qui ne sont pas de type UNIX
SELECT NOM_L 
FROM LOGICIEL 
WHERE TYPE_L != 'UNIX';

-- 6/ Numéro des segments qui contiennent des postes de type UNIX
SELECT DISTINCT N_SEGMENT 
FROM POSTE 
WHERE TYPE_P = 'UNIX';

-- 7/ Numéro des segments qui ne contiennent pas des postes UNIX
SELECT DISTINCT N_SEGMENT 
FROM SEGMENT 
WHERE N_SEGMENT NOT IN (SELECT DISTINCT N_SEGMENT FROM POSTE WHERE TYPE_P = 'UNIX');

-- 8/ Adresse IP et numéros des postes UNIX ou PCWS et sur le segment 130.120.80 triés par numéro de salle décroissant
SELECT AD, N_POSTE 
FROM POSTE 
WHERE TYPE_P IN ('UNIX', 'PCWS') AND N_SEGMENT = '130.120.80' 
ORDER BY N_SALLE DESC;

-- 9/ Numéros des logiciels qui sont installés sur le poste p6
SELECT N_LOG 
FROM INSTALLER 
WHERE N_POSTE = 'p6';

-- 10/ Numéros des postes qui contiennent le logiciel log1
SELECT N_POSTE 
FROM INSTALLER 
WHERE N_LOG = 'log1';

-- 11/ Noms et adresses IP complète des postes de type TX
SELECT NOM_P, CONCAT('130.120.80.', AD) AS IP_COMPLETE 
FROM POSTE 
WHERE TYPE_P = 'TX';

-- 12/ Dates d’installation du logiciel log7
SELECT DATE_INS 
FROM INSTALLER 
WHERE N_LOG = 'log7';

-- 13/ Nombres d’installation
SELECT COUNT(*) AS NOMBRE_INSTALLATIONS 
FROM INSTALLER;

-- 14/ Nombres de poste
SELECT COUNT(*) AS NOMBRE_POSTES 
FROM POSTE;

-- 15/ Nombre de poste (duplication de la 14ème requête, une erreur dans la demande probablement)
SELECT COUNT(*) AS NOMBRE_POSTES 
FROM POSTE;

-- 16/ Pour chaque poste, le nombre de logiciels installés
SELECT N_POSTE, COUNT(N_LOG) AS NOMBRE_LOGICIELS_INSTALLÉS 
FROM INSTALLER 
GROUP BY N_POSTE;

-- 17/ Dans chaque salle, le nombre de postes installés
SELECT N_SALLE, COUNT(N_POSTE) AS NOMBRE_POSTES 
FROM POSTE 
GROUP BY N_SALLE;

-- 18/ Plus récente date d’achat d’un logiciel
SELECT MAX(DATE_ACH) AS DATE_ACHAT_PLUS_RECENTE 
FROM LOGICIEL;

-- 19/ Plus ancienne date d’achat d’un logiciel
SELECT MIN(DATE_ACH) AS DATE_ACHAT_PLUS_ANCIENNE 
FROM LOGICIEL;

-- 20/ Nom du logiciel ayant la date d’achat la plus récente
SELECT NOM_L 
FROM LOGICIEL 
WHERE DATE_ACH = (SELECT MAX(DATE_ACH) FROM LOGICIEL);

-- 21/ Numéro du logiciel qui a été installé en premier
SELECT N_LOG 
FROM INSTALLER 
ORDER BY DATE_INS 
LIMIT 1;

-- 22/ Numéro du logiciel qui a été installé en dernier
SELECT N_LOG 
FROM INSTALLER 
ORDER BY DATE_INS DESC 
LIMIT 1;

-- 23/ Numéros des postes ayant 2 installations de logiciel
SELECT N_POSTE 
FROM INSTALLER 
GROUP BY N_POSTE 
HAVING COUNT(N_LOG) = 2;

-- 24/ Nombres de postes ayant 2 installations de logiciel
SELECT COUNT(N_POSTE) AS NOMBRE_POSTES_2_INSTALLATIONS 
FROM (SELECT N_POSTE 
      FROM INSTALLER 
      GROUP BY N_POSTE 
      HAVING COUNT(N_LOG) = 2) AS TEMP;
