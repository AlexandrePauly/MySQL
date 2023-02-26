/*                         -- TP3 --                       */

/* 2 - Écrire dans un fichier pokemon.sql le script permettant de créer la base de données << Pokemon >>. Exécuter le script. */
drop database if exists Pokemon;
create database Pokemon;

show databases;

/* 3 - Indiquer dans le script que vous allez utiliser cette base de données. */
use Pokemon;

/* 4 - Ajouter dans le fichier, le script permettant la création des tables à partir du MLD précédent. */
create table Equipe (
	idEquipe	int primary key NOT NULL AUTO_INCREMENT,
	nom		 	varchar(9),
	couleur		varchar(5)
);

create table Joueur (
	idJoueur	int primary key NOT NULL AUTO_INCREMENT,
	pseudonyme	varchar(30),
	sexe		char(1),
	niveau		int,
	idEquipe	int NOT NULL,
constraint Joueur_idEquipe foreign key (idEquipe)
			references Equipe (idEquipe)
);

create table Pokemon (
	idPokemon	int primary key NOT NULL AUTO_INCREMENT,
	nom			varchar(30),
	Espece		varchar(20),
	pointCombat	int,
	idJoueur	int,
constraint Pokemon_idJoueur foreign key (idJoueur)
			references Joueur (idJoueur) on delete cascade
);

create table Emplacement (
	idEmplacement	int primary key NOT NULL AUTO_INCREMENT,
	latitude		decimal(10,10),
	longitude		decimal(13,10)
);

create table Apparition (
	idPokemon		int NOT NULL,
	idEmplacement	int NOT NULL,
	dateA			date,
	duree			int,
constraint Apparition_idPokemon_idEmplacement primary key (idPokemon,idEmplacement),
constraint Apparition_idPokemon foreign key (idPokemon)
			references Pokemon (idPokemon) on delete cascade,
constraint Apparition_idEmplacement foreign key (idEmplacement)
			references Emplacement (idEmplacement)
);

/* 5 - Ajouter les instructions au script permettant de modifier le nom de la colonne date dans la table Apparition par horaire */
alter table Apparition rename column dateA to horaire;
describe Apparition;

/* 6 - Mettre comme date par défaut la date du système pour la table Apparition */
alter table Apparition modify horaire date default (current_date);
describe Apparition;

/* 7 - Mettre 0 comme le niveau par défaut. */
alter table Joueur modify niveau int default 0;
describe Joueur;

/* 8 - Rendre obligatoire les informations niveau, latitude, longitude. */
alter table Joueur modify niveau int NOT NULL default 0;
describe Joueur;

alter table Emplacement modify latitude decimal(12,10) NOT NULL;
alter table Emplacement modify longitude decimal(13,10) NOT NULL; 
describe Emplacement;

/* 9 - Le pseudonyme est unique. Modifier la table Joueur. */
alter table Joueur modify pseudonyme varchar(30) UNIQUE;
describe Joueur;

/* 10 - Ajouter la contrainte : Point de combat ≥ 0. */
alter table Pokemon add constraint Pokemon_pointCombat_positif check (pointCombat >= 0);

/* 11 - Ajouter la contrainte : Latitude est entre -90 et 90, longitude est entre -180 et 180. */
alter table Emplacement add constraint Pokemon_latitude_intervalle check (latitude >= -90 and latitude <= 90);
alter table Emplacement add constraint Pokemon_longitude_intervalle check (longitude >= -180 and latitude <= 180);

/*OU alter table Emplacement add constraint Pokemon_latitude_intervalle check (latitude between -90 and 90);*/
/*OU alter table Emplacement add constraint Pokemon_longitude_intervalle check (longitude between -180 and 180);*/

/* 12 - Supprimer la contrainte sur le pseudonyme. */
/*alter table Joueur drop constraint pseudonyme;
OU alter table Joueur drop index pseudonyme;
OU supprimer les tables et les recréer sans l'index ou faire un source Nom_script.sql en ayant enlevé l'index*/

/*                         -- TP4 --                       */

-- Quelques données --

delete from Apparition;
delete from Emplacement;
delete from Pokemon;
delete from Joueur;
delete from Equipe;

insert into Equipe values (null,'Intuition','Jaune');
insert into Equipe values (null,'Sagesse','Bleu');
insert into Equipe values (null,'Bravoure','Rouge');

insert into Joueur values (null,'Shadow','F',10,1);
insert into Joueur values (null,'Elise','F',20,2);
insert into Joueur values (null,'Bob54','M',1,1);

insert into Pokemon values (null,'Bulbizarre','Graine',1071,1);
insert into Pokemon values (25,'Pikachu','Souris',887,2);
insert into Pokemon values (107,'Tygnon','Puncheur',204,1);
insert into Pokemon values (103,'Noadkoko','Fruitpalme',190,3);
insert into Pokemon values (150,'Mewtwo','Génétique',4144,2);

insert into Emplacement values (null,49.0350369,2.0696998);
insert into Emplacement values (null,48.857848,2.295253);
insert into Emplacement values (null,-74.0445,40.6892);

insert into Apparition values (1,2,'2022-10-05',10);
insert into Apparition values (25,1,'2022-09-05',20);
insert into Apparition values (107,3,'2022-10-02',5);
insert into Apparition values (103,1,'2022-10-04',15);
insert into Apparition values (25,3,'2022-10-04',3);

/* 1 - Mettre le niveau de tous les joueurs féminins à 15. */
update Joueur set niveau = 15 where sexe = 'F';
select * from Joueur;

/* 2 - Supprimer les pokémons dont l’espèce contient le mot « que ». */
delete from Pokemon where Espece like '%que%';
select * from Pokemon;

/* 3 - Supprimer le joueur Bob54. */
/*Il faut ajouter on delete cascade dans le schéma de la base sur les clés étrangères idPokemon dans Apparition et idJoueur dans Pokemon*/
delete from Joueur where pseudonyme = 'Bob54';
select * from Joueur;
select * from Pokemon;
select * from Apparition;

/* 4 - Combien d’équipes existent dans la base de données ? */
select count(idEquipe) as Nombre_Equipe
from Equipe;

/* 5 - Quels sont les pokémons dont le nom commence par la lettre p sans tenir compte de la casse ? */
select idPokemon, nom 
from Pokemon
where lower(nom) like 'p%';

-- OU --

select idPokemon, nom 
from Pokemon
where upper(nom) like 'P%';

/* 6 - Quels sont les pseudonymes des joueurs qui ne contiennent pas la lettre a ? */
select idJoueur, pseudonyme 
from Joueur 
where lower(pseudonyme) not like '%a%';

/* 7 - Trier les pokémons selon le point de combat en ordre décroissant. */
select *  
from Pokemon 
order by pointCombat DESC;

/* 8 - Quelle est la date d’apparition du pokemon « Tygnon » ? */
select horaire 
from Apparition 
where idPokemon = (select idPokemon from Pokemon where nom = 'Tygnon');

-- OU --

select horaire 
from Apparition INNER JOIN Pokemon ON Apparition.idPokemon = Pokemon.idPokemon
where nom = 'Tygnon';

-- OU --

select horaire
from Apparition NATURAL JOIN Pokemon
where nom = 'Tygnon';

/* 9 - Calculer la durée moyenne d'apparition des pokémons. */
select avg(duree) as Durée_Moyenne_Apparition
from Apparition;

/* 10 - Compter le nombre d'apparitions des pokémons en octobre 2022. */
select count(idPokemon) as Nombre_Apparition_Octobre_2022
from Apparition 
where horaire between '2022-10-01' and '2022-10-31';

select count(idPokemon) as Nombre_Apparition_Octobre_2022
from Apparition 
where extract(month from horaire) = 10;

select count(idPokemon) as Nombre_Apparition_Octobre_2022
from Apparition 
where month (horaire) = 10; 

/* 11 - Quel est le pokémon le plus fort ? */
select nom 
from Pokemon 
where pointCombat = (select max(pointCombat) 
		     from Pokemon);

/* 12 - Augmenter de 2 le niveau de Shadow. */
update Joueur set niveau = niveau + 2 where pseudonyme = 'Shadow';
select * from Joueur;

/* 13 - Sélectionner les pokémons qui ont apparu en septembre. Ecrire la requête sans utiliser le LIKE.*/
select P.idPokemon, P.nom
from Pokemon P
where idPokemon = (select idPokemon 
				   from Apparition
				   where horaire between '2022-09-01' and '2022-09-30');

/*                         -- TP5 --                       */

create table Arene (
	idArene			int primary key NOT NULL AUTO_INCREMENT,
	nomA			varchar(30),		
	idEmplacement	int,
constraint Arene_idEmplacement foreign key (idEmplacement)
			references Emplacement (idEmplacement)
);

create table Defense (
	idEquipe		int NOT NULL,
	idArene			int NOT NULL,
	dateControle	date NOT NULL,
constraint Defense_idEquipe_idArene_dateControle primary key (idEquipe,idArene,dateControle),
constraint Defense_idEquipe foreign key (idEquipe)
			references Equipe (idEquipe),
constraint Defense_idArene foreign key (idArene)
			references Arene (idArene)
);

-- Suppression des données dans les tables --

delete from Apparition;
delete from Emplacement;
delete from Pokemon;
delete from Joueur;
delete from Equipe;

-- Quelques données --

insert into Equipe values (1,'Intuition','Jaune');
insert into Equipe values (2,'Sagesse','Bleu');
insert into Equipe values (3,'Bravoure','Rouge');

insert into Joueur values (1,'Shadow','F',10,1);
insert into Joueur values (2,'Elise','F',20,2);
insert into Joueur values (3,'Bob54','M',1,1);

insert into Pokemon values (1,'Bulbizarre','Graine',1071,1);
insert into Pokemon values (25,'Pikachu','Souris',887,2);
insert into Pokemon values (107,'Tygnon','Puncheur',204,1);
insert into Pokemon values (103,'Noadkoko','Fruitpalme',190,3);
insert into Pokemon values (150,'Mewtwo','Génétique',4144,2);
insert into Pokemon values (151,'Raichu','Souris',887,2);
insert into Pokemon values (155,'Goupix','Renard',650,3);
insert into Pokemon values (160, 'Sablette','Souris',350,3);

insert into Emplacement values (1,49.0350369,2.0696998);
insert into Emplacement values (2,48.857848,2.295253);
insert into Emplacement values (3,-74.0445,40.6892);

insert into Apparition values (1,2,'2022-10-05',10);
insert into Apparition values (25,1,'2022-09-05',20);
insert into Apparition values (107,3,'2022-10-02',5);
insert into Apparition values (103,1,'2022-10-04',15);
insert into Apparition values (25,3,'2022-10-04',3);
insert into Apparition values (160,1,'2022-10-15',18);
insert into Apparition values (107,1,'2022-10-16',5);

insert into Arene values (1, 'Liberte', 3);
insert into Arene values (2, 'CyTech', 1);
insert into Arene values (3, 'Star', 2);

insert into Defense values (1, 1, '2022-10-04');
insert into Defense values (1, 2, '2022-09-01');

/* 1 - Quelle est la durée d’apparition la plus récente ? */
select horaire, duree
from Apparition
where horaire = (select max(horaire) from Apparition);

/* 2 - Donner les noms des pokémons qui ont le même point de combat et le même maître que 'Pikachu'. */
select nom
from Pokemon
where nom != 'Pikachu'
      and (pointCombat, idJoueur) = (select pointCombat, idJoueur
				      from Pokemon
				      where nom = 'Pikachu');
				      
/* 3 - Quels sont les joueurs dont le pseudonyme est plus court que tous les psudonymes de joueurs ? */
select idJoueur, pseudonyme 
from Joueur 
where length(pseudonyme) = (select min(length(pseudonyme)) 
							from Joueur);

/* 4 - Afficher toutes les dates de prise de contrôle des arènes, ainsi que les horaires des apparitions des pokémons. */
select dateControle, horaire
from Apparition A, Defense D, Arene Ar
where A.idEmplacement = Ar.idEmplacement
      and Ar.idArene = D.idArene;

-- OU --
      
select dateControle
from Defense UNION (select horaire
		            from Apparition);

/* 5 - Quelles sont les dates où il y a à la fois l'apparition d'un pokémon et la prise de contrôle d'une arène ? */
select distinct horaire
from Apparition, Defense
where horaire = dateControle;

-- OU --

select horaire
from Apparition A, Defense D, Arene Ar
where A.idEmplacement = Ar.idEmplacement
      and Ar.idArene = D.idArene
      and A.horaire = D.dateControle;	

/* 6 - Quels sont les joueurs dont le pseudonyme commence par la lettre B ou S et ne s’appelle pas Bob ? */
select pseudonyme
from Joueur
where pseudonyme not like '%Bob%' and pseudonyme IN (select pseudonyme from Joueur
													 where pseudonyme like 'S%' or pseudonyme like 'B%');

-- OU --

select pseudonyme 
from Joueur 
where (pseudonyme LIKE 'B%' OR pseudonyme LIKE 'S%') 
	   and pseudonyme NOT LIKE 'BOB%';

/* 7 - Quels sont les noms des pokémons du joueur Bob54 ? */
select nom
from Pokemon P, Joueur J
where P.idJoueur = J.idJoueur
	  and pseudonyme = 'Bob54';

/* 8 - Quels sont les joueurs qui n’ont jamais eu de pokémons de type souris ? */
select J.idJoueur, pseudonyme
from Joueur J 
where idJoueur NOT IN (select idJoueur 
					   from Pokemon 
					   where Espece = 'souris');
			
/* 9 - Quelle est l'équipe du joueur Shadow ? */
select idEquipe, nom
from Equipe NATURAL JOIN Joueur
where pseudonyme = 'Shadow';

/* 10 - Quels sont les pokémons qui n'ont pas encore apparu ? Affichez les id et les noms des pokémons. */
select idPokemon, nom
from Pokemon
where idPokemon NOT IN (select idPokemon 
						from Apparition);

/* 11 - Quelle est la latitude et la longitude de l'endroit où un pokémon d'espèce Fruitpalme a apparu le 04 octobre 2022? */
select E.idEmplacement, latitude, longitude
from Emplacement E, Apparition A, Pokemon P
where E.idEmplacement = A.idEmplacement 
      and A.idPokemon = P.idPokemon 
      and Espece = 'Fruitpalme' 
      and horaire = '2022-10-04';
      
/* 12 - Quels sont les pokémons meilleurs que ceux de l’équipe Jaune ? */
select idPokemon, nom
from Pokemon P
where pointCombat > ALL (select pointCombat
						 from Pokemon P, Joueur J, Equipe E
						 where P.idJoueur = J.idJoueur
							   and J.idEquipe = E.idEquipe
						       and couleur = 'Jaune');

/* 13 - Combien de pokémons ont apparu dans l’arène CyTech ? */
select count(idPokemon) as Nb_Pokemon_Apparition_CyTech
from Apparition A, Arene Ar
where A.idEmplacement = Ar.idEmplacement
      and nomA = 'CyTech';
      
/* 14 - De combien d'arènes l'équipe Intuition a pris le contrôle? */
select count(D.idEquipe) as Nb_Arene_Intuition
from Defense D NATURAL JOIN Equipe
where nom = 'Intuition';

/* 15 - Quelle est la date de la première apparition de Tygnon ? */
select min(horaire) as Première_Apparition_Tygnon
from Apparition NATURAL JOIN Pokemon
where nom = 'Tygnon';

/* 16 - Quelle est la moyenne des points de combat de chaque espèce de pokémon ? */
select Espece, avg(pointCombat) as Moyenne_PC
from Pokemon
group by Espece;

/* 17 - Compter le nombre de pokémons de chaque joueur. Le pseudonyme du joueur suffit
dans la réponse. */
select pseudonyme, count(idPokemon) as 'Nb Pokemon'
from Joueur NATURAL JOIN Pokemon
group by pseudonyme;

/* 18 - Pour chaque joueur, afficher son pseudonyme, son équipe et le nombre de pokémons
qu'il possède. */
select pseudonyme, idEquipe, count(idPokemon) as 'Nb Pokemon'
from Joueur NATURAL JOIN Pokemon
group by pseudonyme, idEquipe;

/* 19 - Pour chaque pokémon, donner le nom et la durée totale d'apparition. */
select nom, sum(duree) as 'Durée totale d''apparition'
from Pokemon NATURAL JOIN Apparition
group by nom;

/* 20 - Pour chaque pokémon, donner son nom, son espèce et le nombre d'apparitions. Nous sommes intéressés seulement aux pokémons qui ont apparu au moins 2 fois. */
select nom, Espece, count(A.idPokemon) as 'Nombre d''apparition'
from Pokemon NATURAL JOIN Apparition A
group by nom, espece
having count(A.idPokemon)>=2;

/* 21 - Pour chaque pokémon, donner son nom, son espèce et le nombre d'apparitions dont la durée est supérieure à 5 minutes. */
select nom, Espece, count(A.idPokemon) as 'Nombre d''apparition supérieure à 5min'
from Pokemon NATURAL JOIN Apparition A
where duree > 5
group by nom, espece;

/* 22 - Pour chaque pokémon de plus de 1000 points de combat, donner son nom, son espèce et la durée totale d’apparition. Nous sommes intéressés seulement aux pokémons qui ont apparu au moins 10 minutes. */
select nom, Espece, sum(duree) as 'Durée totale d''apparition'
from Pokemon NATURAL JOIN Apparition
where pointCombat > 1000
group by nom, Espece
having sum(duree)>=10;

/* 23 - Donner le temps moyen d’apparition des pokémons appartenant aux joueurs de l’équipe ayant contrôlé le plus d’arènes. */
select avg(duree) as 'Temps moyen d''apparition'
from Apparition A, Pokemon P, Joueur J, Defense D
where A.idPokemon = P.idPokemon
      and P.idJoueur = J.idJoueur
      and J.idEquipe = D.idEquipe
      and J.idEquipe = (select idEquipe
      			 		from Defense
      			 		group by idEquipe
      			 		having count(*) = (select max(TotArC) 
      			 		    			   from (select idEquipe, count(idArene) as TotArC 
      			 		    	  				 from Defense
						  						 group by idEquipe) 
										   as total));
						  
/*                         -- TP6 --                       */

/* 1 - Quelle est la durée d’apparition la plus récente ? */
select duree
from Apparition
where horaire = (select max(horaire)
				 from Apparition);

/* 2 - Classez les pokémons en fonction du nombre d'apparitions. Nous sommes intéressés par les Pokémons qui ne sont pas encore apparu également (dont le nombre d'apparition vaut 0). */
select nom, count(A.idPokemon) as 'Nombre d''apparition'
from Pokemon P LEFT JOIN Apparition A ON P.idPokemon = A.idPokemon
group by nom
order by count(A.idPokemon) desc;
			
/* 3 - Quels sont les pokémons dont le nombre d'apparitions est supérieur au nombre moyen d'apparitions ? */
select nom, count(idEmplacement) as 'Nombre d''apparition'
from Apparition A NATURAL JOIN Pokemon P
group by nom
having count(idemplacement) > (select avg(idEmplacement)
				    		   from Apparition);
				
/* 4 - On veut obtenir le pseudonyme, le sexe, le niveau et le nombre de pokémons de tous les joueurs, y compris ceux qui n'ont capturé aucun Pokémon. Triez votre résultat. */
select pseudonyme, sexe, niveau, count(idPokemon)
from Joueur J LEFT JOIN Pokemon P ON J.idJoueur = P.idJoueur
group by pseudonyme, sexe, niveau
order by count(idPokemon) desc;

/* 5 - Quels sont les pokémons qui ont apparu dans tous les emplacements différents ? */
select nom
from Pokemon NATURAL JOIN Apparition A
group by nom
having count(distinct A.idEmplacement) = (select count( idEmplacement)
					   					  from Emplacement);
					 
/* 6 - Quels sont les joueurs qui ont capturé toutes les espèces de pokémon ? */
select pseudonyme
from Joueur NATURAL JOIN Pokemon
group by pseudonyme
having count(distinct Espece) = (select count(distinct Espece)
				   				 from Pokemon);
				   
/* 7 - Combien de joueurs possèdent des pokémons qui sont placés dans l'emplacement avec
la latitude la plus septentrionale (la plus haute) ? */
select count(distinct idJoueur) as 'Nombre de Joueurs'
from Pokemon P, Apparition A, Emplacement E
where P.idPokemon = A.idPokemon
      and A.idEmplacement = E.idEmplacement
      and latitude = (select max(latitude) as 'Latitude la plus septentrionale' 
      		      	  from Emplacement);
      
/* 8 - Quelle est l'équipe qui a pris le contrôle d'une arène plus souvent ? */
select E.idEquipe, nom
from Equipe E NATURAL JOIN Defense D
group by E.idEquipe, nom
having count(idArene) = (select max(TotArC)
			  			 from (select count(idArene) as TotArC
			  				   from Defense
			  				   group by idEquipe) 
						 as Total);
			 
/* 9 - Quelle est la plage des dates auxquelles les pokémons de l'équipe de la question
précédente ont apparu ? */
select min(horaire) as 'A contrôlé des arènes à partir du', max(horaire) as 'Jusqu''au'
from Joueur J NATURAL JOIN Pokemon P NATURAL JOIN Apparition A
where J.idEquipe = (select E.idEquipe
					from Equipe E NATURAL JOIN Defense D
					group by E.idEquipe
					having count(idArene) = (select max(TotArC)
											 from (select count(idArene) as TotArC
												   from Defense
												   group by idEquipe) 
											 as Total));

/* 10 - Affichez les joueurs dont le niveau est le plus élevé de leur équipe. */
select nom, max(niveau) 
from Joueur J RIGHT JOIN Equipe E ON J.idEquipe = E.idEquipe
group by nom;