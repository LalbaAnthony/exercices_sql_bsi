-- ====================================
-- Question 1
-- ====================================

-- Créer la vue LOGICIELS_UNIX à partir de la table LOGICIEL ne contenant que les logiciels de type UNIX.

CREATE VIEW LOGICIELS_UNIX AS
SELECT
    *
FROM
    LOGICIEL
WHERE
    TYPE_L = 'UNIX';

-- Vérifier la structure de la vue
DESC LOGICIELS_UNIX;

-- Interroger la vue
SELECT
    *
FROM
    LOGICIELS_UNIX;

-- ====================================
-- Question 2
-- ====================================

-- Créer la vue POSTE_0 à partir de la table POSTE ne contenant que les postes du rez-de-chaussée.

CREATE VIEW POSTE_0 (NPOS0, NSAL0, TYP0, NSEG0, A0) AS
SELECT
    p.N_POSTE,
    p.N_SALLE,
    p.TYPE_P,
    p.N_SEGMENT,
    p.AD
FROM
    POSTE p
    JOIN SEGMENT s ON p.N_SEGMENT = s.N_SEGMENT
WHERE
    s.NOM_SEGMENT LIKE 'rez-de-chaussée%';

-- Vérifier la structure de la vue
DESC POSTE_0;

-- Interroger la vue
SELECT
    *
FROM
    POSTE_0;

-- Insérer deux nouveaux postes dans la vue
INSERT INTO
    POSTE_0 (NPOS0, NSAL0, TYP0, NSEG0, A0)
VALUES
    ('p15', 's01', 'TX', '130.120.80', 8);

INSERT INTO
    POSTE_0 (NPOS0, NSAL0, TYP0, NSEG0, A0)
VALUES
    ('p16', 's02', 'PCWS', '130.120.81', 9);

-- Vérifier le contenu de la vue et de la table POSTE
SELECT
    *
FROM
    POSTE_0;

SELECT
    *
FROM
    POSTE;

-- Supprimer les deux enregistrements de la table POSTE
DELETE FROM
    POSTE
WHERE
    N_POSTE IN ('p15', 'p16');

-- ====================================
-- Question 3
-- ====================================

-- Créer la vue SALLE_PRIX à partir de la table SALLE contenant le prix de location pour une journée.

CREATE VIEW SALLE_PRIX (N_SALLE, NOM_S, NB_POSTE, PRIX_LOCATION) AS
SELECT
    N_SALLE,
    NOM_S,
    NB_POSTE,
    100 * NB_POSTE AS PRIX_LOCATION
FROM
    SALLE;

-- Vérifier le contenu de la vue
SELECT
    *
FROM
    SALLE_PRIX;

-- Afficher les salles dont le prix de location dépasse un montant donné (exemple: 200€)
SELECT
    *
FROM
    SALLE_PRIX
WHERE
    PRIX_LOCATION > 200;

-- ====================================
-- Question 4
-- ====================================

-- Créer la vue SALLE_POSTE pour la liste des installations des postes dans toutes les salles.

CREATE VIEW SALLE_POSTE AS
SELECT
    s.NOM_S,
    p.NOM_P,
    p.N_SEGMENT || '.' || p.AD AS AD_COMPLET,
    CASE
        WHEN p.TYPE_P = 'TX' THEN 'Terminal X-Window'
        WHEN p.TYPE_P = 'UNIX' THEN 'Système Unix'
        WHEN p.TYPE_P = 'PCWS' THEN 'PC Windows' -- ajouter les autres types si nécessaire
    END AS DESCRIPTION
FROM
    POSTE p
    JOIN SALLE s ON p.N_SALLE = s.N_SALLE;

-- Vérifier le contenu de la vue
SELECT
    *
FROM
    SALLE_POSTE;

-- ====================================
-- Question 5
-- ====================================

-- Ajouter la colonne TARIF à la table TYPE et mettre à jour cette table avec les valeurs données.

-- Ajouter la colonne TARIF
ALTER TABLE
    TYPE
ADD
    TARIF NUMBER;

-- Mettre à jour la table TYPE
UPDATE
    TYPE
SET
    TARIF = 50
WHERE
    NOM_TYPE = 'TX';

UPDATE
    TYPE
SET
    TARIF = 100
WHERE
    NOM_TYPE = 'PCWS';

UPDATE
    TYPE
SET
    TARIF = 120
WHERE
    NOM_TYPE = 'PCNT';

UPDATE
    TYPE
SET
    TARIF = 200
WHERE
    NOM_TYPE = 'UNIX';

UPDATE
    TYPE
SET
    TARIF = 400
WHERE
    NOM_TYPE = 'BeOS';

Créer la vue SALLE_1 en groupant sur 3 colonnes.CREATE VIEW SALLE_1 (N_SALLE, TYPEP, NOMBRE, TARIF) AS
SELECT
    p.N_SALLE,
    p.TYPE_P,
    COUNT(*) AS NOMBRE,
    t.TARIF
FROM
    POSTE p
    JOIN TYPE t ON p.TYPE_P = t.NOM_TYPE
GROUP BY
    p.N_SALLE,
    p.TYPE_P,
    t.TARIF;

-- Vérifier le contenu de la vue
SELECT
    *
FROM
    SALLE_1;

-- ====================================
-- Question 6
-- ====================================

-- Créer la vue SALLE_PRIX_TOTAL à partir de la vue SALLE_1.

CREATE VIEW SALLE_PRIX_TOTAL (N_SALLE, PRIX_LOCATION) AS
SELECT
    N_SALLE,
    SUM(NOMBRE * TARIF) AS PRIX_LOCATION
FROM
    SALLE_1
GROUP BY
    N_SALLE;

-- Vérifier le contenu de la vue
SELECT
    *
FROM
    SALLE_PRIX_TOTAL;

-- ====================================
-- Question 7
-- ====================================

-- Reprendre la vue POSTE_0 avec l’option de contrôle.

CREATE
OR REPLACE VIEW POSTE_0 (NPOS0, NSAL0, TYP0, NSEG0, A0) AS
SELECT
    p.N_POSTE,
    p.N_SALLE,
    p.TYPE_P,
    p.N_SEGMENT,
    p.AD
FROM
    POSTE p
    JOIN SEGMENT s ON p.N_SEGMENT = s.N_SEGMENT
WHERE
    s.NOM_SEGMENT LIKE 'rez-de-chaussée%' WITH CHECK OPTION;

-- Tenter d’insérer un poste appartenant à un étage différent de 0 (cela doit échouer)
INSERT INTO
    POSTE_0 (NPOS0, NSAL0, TYP0, NSEG0, A0)
VALUES
    ('p17', 's03', 'TX', '130.120.81', 10);

-- ====================================
-- Question 8
-- ====================================

-- Créer la vue INSTALLER_0 pour ne permettre que les postes du rez-de-chaussée et interdire l’installation de logiciels de type UNIX.

CREATE VIEW INSTALLER_0 (N_POSTE, N_LOG, DATE_INS) AS
SELECT
    i.N_POSTE,
    i.N_LOG,
    i.DATE_INS
FROM
    INSTALLER i
    JOIN POSTE p ON i.N_POSTE = p.N_POSTE
    JOIN SEGMENT s ON p.N_SEGMENT = s.N_SEGMENT
    JOIN LOGICIEL l ON i.N_LOG = l.N_LOG
WHERE
    s.NOM_SEGMENT LIKE 'rez-de-chaussée%'
    AND l.TYPE_L <> 'UNIX' WITH CHECK OPTION;

-- Tenter d’insérer des enregistrements ne respectant pas les contraintes (cela doit échouer)
INSERT INTO
    INSTALLER_0 (N_POSTE, N_LOG, DATE_INS)
VALUES
    ('p18', 'log3', '2021-06-01');

INSERT INTO
    INSTALLER_0 (N_POSTE, N_LOG, DATE_INS)
VALUES
    ('p1', 'log1', '2021-06-01');

