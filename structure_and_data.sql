/*on supprime les tables avant de les créer : action faite au cas ou la table existe déjà.
Autre possibilité : IF NOT EXISTS*/
DROP TABLE INSTALLER;
DROP TABLE LOGICIEL;
DROP TABLE POSTE;
DROP TABLE SALLE;
DROP TABLE SEGMENT;
/*creation des tables */
CREATE TABLE SEGMENT
(N_SEGMENT varchar(10),
/*NOT NULL pour éviter d’avoir une colonne sans DATA*/
NOM_SEGMENT varchar(20) NOT NULL,
/*contrainte pour créer la PK avec l’alias*/
CONSTRAINT PKN_SEGMENT PRIMARY KEY(N_SEGMENT));
CREATE TABLE SALLE
(N_SALLE varchar(7),NOM_S varchar(20) NOT NULL,NB_POSTE varchar(7), N_SEGMENT
varchar(30),
CONSTRAINT PKN_SALLE PRIMARY KEY (N_SALLE),
/*contrainte pour créer la FK. Nous sommes dans une BD Relationnelle donc on utilise les PK et
FK pour établier des liens. On fait donc reference à la table et sa PK dans la table initiale */
CONSTRAINT FKN_SEGMENT FOREIGN KEY (N_SEGMENT) REFERENCES
SEGMENT(N_SEGMENT)
);
CREATE TABLE POSTE(
N_POSTE VARCHAR(7),NOM_P varchar(30) NOT NULL,N_SEGMENT varchar(10), AD int,
TYPE_P varchar(6), N_SALLE varchar(7),
CONSTRAINT AD CHECK (AD BETWEEN 0 AND 255),
CONSTRAINT PKN_POSTE PRIMARY KEY (N_POSTE),
CONSTRAINT FKN_SALLE FOREIGN KEY(N_SALLE) REFERENCES SALLE(N_SALLE)
);
CREATE TABLE LOGICIEL(
N_LOG varchar(5),NOM_L varchar(20),DATE_ACH date, VERSION varchar(7), TYPE_L
varchar(6),
CONSTRAINT PKN_LOG PRIMARY KEY(N_LOG)
);
CREATE TABLE INSTALLER(
N_POSTE varchar(7),N_LOG varchar(5), DATE_INS date,
CONSTRAINT PKN_POSTE_N_LOG PRIMARY KEY(N_POSTE,N_LOG),
CONSTRAINT FKN_POSTE FOREIGN KEY(N_POSTE) REFERENCES POSTE(N_POSTE),
CONSTRAINT FKN_LOG FOREIGN KEY(N_LOG) REFERENCES LOGICIEL(N_LOG)
);

plus les information à entrer
DELETE FROM installer;

DELETE FROM poste;
DELETE FROM salle;
DELETE FROM segment;
DELETE FROM logiciel;
--
/*possibilité de faire un seul INSERT pour inserer les datas. */
INSERT INTO segment(n_segment,nom_segment)
VALUES ('130.120.80','segment 80');
INSERT INTO segment(n_segment,nom_segment)
VALUES ('130.120.81','segment 81');
INSERT INTO segment(n_segment,nom_segment)
VALUES ('130.120.82','segment 82');
--
INSERT INTO salle(n_salle,nom_s,nb_poste,n_segment)
VALUES ('s01','Salle 1',3,'130.120.80');
INSERT INTO salle(n_salle,nom_s,nb_poste,n_segment)
VALUES ('s02','Salle 2',2,'130.120.80');
INSERT INTO salle(n_salle,nom_s,nb_poste,n_segment)
VALUES ('s03','Salle 3',2,'130.120.80');
INSERT INTO salle(n_salle,nom_s,nb_poste,n_segment)
VALUES ('s11','Salle 11',2,'130.120.81');
INSERT INTO salle(n_salle,nom_s,nb_poste,n_segment)
VALUES ('s12','Salle 12',1,'130.120.81');
INSERT INTO salle(n_salle,nom_s,nb_poste,n_segment)
VALUES ('s21','Salle 21',2,'130.120.82');
--
INSERT INTO poste(n_poste,nom_p,n_segment,ad,type_p,n_salle)
VALUES ('p1','Poste 1','130.120.80','01','TX','s01');
INSERT INTO poste(n_poste,nom_p,n_segment,ad,type_p,n_salle)
VALUES ('p2','Poste 2','130.120.80','02','UNIX','s01');
INSERT INTO poste(n_poste,nom_p,n_segment,ad,type_p,n_salle)
VALUES ('p3','Poste 3','130.120.80','03','TX','s01');
INSERT INTO poste(n_poste,nom_p,n_segment,ad,type_p,n_salle)
VALUES ('p4','Poste 4','130.120.80','04','PCWS','s02');
INSERT INTO poste(n_poste,nom_p,n_segment,ad,type_p,n_salle)
VALUES ('p5','Poste 5','130.120.80','05','PCWS','s02');
INSERT INTO poste(n_poste,nom_p,n_segment,ad,type_p,n_salle)
VALUES ('p6','Poste 6','130.120.80','06','UNIX','s03');
INSERT INTO poste(n_poste,nom_p,n_segment,ad,type_p,n_salle)
VALUES ('p7','Poste 7','130.120.80','07','TX','s03');
INSERT INTO poste(n_poste,nom_p,n_segment,ad,type_p,n_salle)
VALUES ('p8','Poste 8','130.120.81','01','UNIX','s11');
INSERT INTO poste(n_poste,nom_p,n_segment,ad,type_p,n_salle)
VALUES ('p9','Poste 9','130.120.81','02','TX','s11');
--
INSERT INTO poste(n_poste,nom_p,n_segment,ad,type_p,n_salle)
VALUES ('p10','Poste 10','130.120.81','03','UNIX','s12');
INSERT INTO poste(n_poste,nom_p,n_segment,ad,type_p,n_salle)
VALUES ('p11','Poste 11','130.120.82','01','PCNT','s21');
INSERT INTO poste(n_poste,nom_p,n_segment,ad,type_p,n_salle)
VALUES ('p12','Poste 12','130.120.82','02','PCWS','s21');
--

INSERT INTO logiciel(n_log,nom_l,date_ach,version,type_l)
VALUES ('log1','Oracle 7','2021-05-13','7.3.2','UNIX');
INSERT INTO logiciel(n_log,nom_l,date_ach,version,type_l)
VALUES ('log2','Oracle 8','2021-09-15','8.0','UNIX');
INSERT INTO logiciel(n_log,nom_l,date_ach,version,type_l)
VALUES ('log3','Sql server','2021-12-04','7','Serv');
INSERT INTO logiciel(n_log,nom_l,date_ach,version,type_l)
VALUES ('log4','Front Page','2021-06-30','5','PCWS');
INSERT INTO logiciel(n_log,nom_l,date_ach,version,type_l)
VALUES ('log5','WinDev','2021-05-12','5','PCWS');
INSERT INTO logiciel(n_log,nom_l,date_ach,version,type_l)
VALUES ('log6','Sql*Net','2021-05-13','2.0','UNIX');
INSERT INTO logiciel(n_log,nom_l,date_ach,version,type_l)
VALUES ('log7','I. I. S.','2021-04-12','2','Ser');
INSERT INTO logiciel(n_log,nom_l,date_ach,version,type_l)
VALUES ('log8','DreamWeaver','2021-09-21','2.0','OS');
--
INSERT INTO installer(n_poste,n_log,date_ins)
VALUES ('p2','log1','2021-05-15');
INSERT INTO installer(n_poste,n_log,date_ins)
VALUES ('p2','log2','2021-09-17');
INSERT INTO installer(n_poste,n_log,date_ins)
VALUES ('p4','log5','2021-05-30');
INSERT INTO installer(n_poste,n_log,date_ins)
VALUES ('p6','log6','2021-05-20');
INSERT INTO installer(n_poste,n_log,date_ins)
VALUES ('p6','log1','2021-05-20');
INSERT INTO installer(n_poste,n_log,date_ins)
VALUES ('p8','log2','2021-05-19');
INSERT INTO installer(n_poste,n_log,date_ins)
VALUES ('p8','log6','2021-05-20');
INSERT INTO installer(n_poste,n_log,date_ins)
VALUES ('p11','log3','2021-04-20');
INSERT INTO installer(n_poste,n_log,date_ins)
VALUES ('p12','log4','2021-04-20');
INSERT INTO installer(n_poste,n_log,date_ins)
VALUES ('p11','log7','2021-04-20');
INSERT INTO installer(n_poste,n_log,date_ins)
VALUES ('p7','log7','2021-04-21');
--
commit;