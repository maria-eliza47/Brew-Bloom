SET DEFINE OFF;

--Stergerea tabelelor
ALTER TABLE DETALII_COMANDA DROP CONSTRAINT FK_DETALII_COMANDA_COMANDA;
ALTER TABLE DETALII_COMANDA DROP CONSTRAINT FK_DETALII_COMANDA_PRODUS;

ALTER TABLE STOC DROP CONSTRAINT FK_STOC_PRODUS;
ALTER TABLE STOC DROP CONSTRAINT FK_STOC_MAGAZIN;

DROP TABLE DETALII_COMANDA CASCADE CONSTRAINTS;
DROP TABLE STOC CASCADE CONSTRAINTS;
DROP TABLE COMANDA CASCADE CONSTRAINTS;
DROP TABLE PRODUS CASCADE CONSTRAINTS;
DROP TABLE CATEGORIE CASCADE CONSTRAINTS;
DROP TABLE MAGAZIN CASCADE CONSTRAINTS;
DROP TABLE LOCATIE CASCADE CONSTRAINTS;
DROP TABLE CLIENT CASCADE CONSTRAINTS;
DROP TABLE ANGAJAT CASCADE CONSTRAINTS;
DROP TABLE METODA_PLATA CASCADE CONSTRAINTS;


--Client
CREATE TABLE Client (
    CNP VARCHAR(13) PRIMARY KEY,   
    Nume VARCHAR(30) NOT NULL,    
    Prenume VARCHAR(30) NOT NULL,
    Email VARCHAR(50) UNIQUE,     
    Telefon VARCHAR(15),
    CHECK (SUBSTR(CNP, 1, 1) IN ('1', '2', '5', '6')) 
);
ALTER TABLE Client 
ADD CONSTRAINT CK_Client_CNP_Format CHECK (LENGTH(CNP) = 13);

--Comanda
CREATE TABLE Comanda (
    ID_Comanda INT PRIMARY KEY,       
    Data_Plasarii DATE DEFAULT SYSDATE,    
    Total DECIMAL(10, 2) NOT NULL      
);

ALTER TABLE Comanda 
ADD CONSTRAINT CK_Comanda_Total CHECK (Total > 0);

ALTER TABLE Comanda
ADD CNP VARCHAR(13) NOT NULL;

ALTER TABLE Comanda
ADD CONSTRAINT FK_Comanda_Client FOREIGN KEY (CNP)
REFERENCES Client(CNP) ON DELETE CASCADE;

--Metoda_Plata
CREATE TABLE Metoda_Plata (
    ID_Metoda INT PRIMARY KEY,          
    Tip_plata VARCHAR(30) NOT NULL,    
    Status VARCHAR(10) NOT NULL,        
    Data_adaugare DATE NOT NULL         
);

ALTER TABLE Comanda
ADD ID_Metoda INT NOT NULL;

ALTER TABLE Comanda
ADD CONSTRAINT FK_Comanda_Metoda FOREIGN KEY (ID_Metoda)
REFERENCES Metoda_Plata(ID_Metoda) ON DELETE CASCADE;

--Produs
CREATE TABLE Produs (
    ID_Produs INT PRIMARY KEY,         
    Nume_Produs VARCHAR(50) NOT NULL, 
    Pret DECIMAL(10, 2) NOT NULL                    
);

--Categorie
CREATE TABLE Categorie (
    ID_Categorie INT PRIMARY KEY,    
    Nume_Categorie VARCHAR(30) NOT NULL, 
    Status VARCHAR(10) NOT NULL        
);

ALTER TABLE Produs
ADD ID_Categorie INT NOT NULL;

ALTER TABLE Produs
ADD CONSTRAINT FK_Produs_Categorie FOREIGN KEY (ID_Categorie)
REFERENCES Categorie(ID_Categorie) ON DELETE CASCADE;

--Magazin (Cafenea)
CREATE TABLE Magazin (
    ID_Magazin INT PRIMARY KEY,         
    Nume_Magazin VARCHAR(50) NOT NULL, 
    Telefon VARCHAR(15)                
);

--Locatie
CREATE TABLE Locatie (
    ID_Locatie INT PRIMARY KEY,        
    Strada VARCHAR(50) NOT NULL,     
    Numar_Strada VARCHAR(10),          
    Oras VARCHAR(30) NOT NULL,        
    Cod_Postal VARCHAR(10)             
);

ALTER TABLE Magazin
ADD ID_Locatie INT NOT NULL;

ALTER TABLE Magazin
ADD CONSTRAINT FK_Magazin_Locatie FOREIGN KEY (ID_Locatie)
REFERENCES Locatie(ID_Locatie) ON DELETE CASCADE;


--Angajat
CREATE TABLE Angajat (
    ID_Angajat INT PRIMARY KEY,                    
    Nume VARCHAR(30) NOT NULL,        
    Prenume VARCHAR(30) NOT NULL,     
    Email VARCHAR(50) UNIQUE,        
    Telefon VARCHAR(15),              
    Salariu DECIMAL(10, 2)         
);

ALTER TABLE Angajat
ADD ID_Magazin INT NOT NULL;

ALTER TABLE Angajat
ADD CONSTRAINT FK_Angajat_Magazin FOREIGN KEY (ID_Magazin)
REFERENCES Magazin(ID_Magazin) ON DELETE CASCADE;

--Detalii Comanda
CREATE TABLE Detalii_Comanda (
    ID_Comanda INT NOT NULL,
    ID_Produs INT NOT NULL,
    Cantitate INT NOT NULL,
    Pret_Unitar DECIMAL(10, 2) NOT NULL,
    CONSTRAINT PK_Detalii_Comanda PRIMARY KEY (ID_Comanda, ID_Produs),
    CONSTRAINT FK_Detalii_Comanda_Comanda FOREIGN KEY (ID_Comanda)
        REFERENCES Comanda(ID_Comanda) ON DELETE CASCADE,
    CONSTRAINT FK_Detalii_Comanda_Produs FOREIGN KEY (ID_Produs)
        REFERENCES Produs(ID_Produs) ON DELETE CASCADE
);

--Stoc
CREATE TABLE Stoc (
    ID_Produs INT NOT NULL,
    ID_Magazin INT NOT NULL,
    Cantitate INT NOT NULL,
    Stare_Stoc VARCHAR(15) DEFAULT 'Disponibil' NOT NULL,
    CONSTRAINT PK_Stoc PRIMARY KEY (ID_Produs, ID_Magazin),
    CONSTRAINT FK_Stoc_Produs FOREIGN KEY (ID_Produs)
        REFERENCES Produs(ID_Produs) ON DELETE CASCADE,
    CONSTRAINT FK_Stoc_Magazin FOREIGN KEY (ID_Magazin)
        REFERENCES Magazin(ID_Magazin) ON DELETE CASCADE
);

--Inserari

--Client
INSERT INTO Client (CNP, Nume, Prenume, Email, Telefon) 
VALUES ('2800129076532', 'Albu', 'Diana', 'diana.albu@yahoo.com', '0722123456');

INSERT INTO Client (CNP, Nume, Prenume, Email, Telefon) 
VALUES ('5050923075141', 'Stan', 'Mihai', 'mihai.stan@gmail.com', '0734567890');

INSERT INTO Client (CNP, Nume, Prenume, Email, Telefon) 
VALUES ('2990529077520', 'Costea', 'Irina', 'irina.costea@icloud.com', '0741234567');

INSERT INTO Client (CNP, Nume, Prenume, Email, Telefon) 
VALUES ('5051015075959', 'Tudor', 'Alexandru', 'alex.tudor@gmail.com', '0759876543');

INSERT INTO Client (CNP, Nume, Prenume, Email, Telefon) 
VALUES ('2602042907564', 'Moldovan', 'Cristina', 'cristina.moldovan@yahoo.com', '0765432123');

INSERT INTO Client (CNP, Nume, Prenume, Email, Telefon) 
VALUES ('5020619074364', 'Iacob', 'Florin', 'florin.iacob@gmail.com', '0776543210');

INSERT INTO Client (CNP, Nume, Prenume, Email, Telefon) 
VALUES ('6050411074101', 'Dragos', 'Andreea', 'andreea.dragos@yahoo.com', '0787654321');

INSERT INTO Client (CNP, Nume, Prenume, Email, Telefon) 
VALUES ('5241225073610', 'Badea', 'Catalin', 'catalin.badea@gmail.com', '0791234560');

INSERT INTO Client (CNP, Nume, Prenume, Email, Telefon) 
VALUES ('6050623078797', 'Stancu', 'Oana', 'oana.stancu@icloud.com', '0701234567');

INSERT INTO Client (CNP, Nume, Prenume, Email, Telefon) 
VALUES ('1970725070980', 'Avram', 'Daniel', 'daniel.avram@yahoo.com', '0712345678');


--Metoda_Plata
INSERT INTO Metoda_Plata (ID_Metoda, Tip_plata, Status, Data_adaugare) VALUES (1, 'Card bancar', 'Activ', SYSDATE);
INSERT INTO Metoda_Plata (ID_Metoda, Tip_plata, Status, Data_adaugare) VALUES (2, 'Numerar', 'Activ', SYSDATE);
INSERT INTO Metoda_Plata (ID_Metoda, Tip_plata, Status, Data_adaugare) VALUES (3, 'Transfer bancar', 'Inactiv', SYSDATE);
INSERT INTO Metoda_Plata (ID_Metoda, Tip_plata, Status, Data_adaugare) VALUES (4, 'Apple Pay', 'Activ', SYSDATE);
INSERT INTO Metoda_Plata (ID_Metoda, Tip_plata, Status, Data_adaugare) VALUES (5, 'Google Pay', 'Activ', SYSDATE);
INSERT INTO Metoda_Plata (ID_Metoda, Tip_plata, Status, Data_adaugare) VALUES (6, 'Revolut', 'Activ', SYSDATE);
INSERT INTO Metoda_Plata (ID_Metoda, Tip_plata, Status, Data_adaugare) VALUES (7, 'Bitcoin', 'Inactiv', SYSDATE);
INSERT INTO Metoda_Plata (ID_Metoda, Tip_plata, Status, Data_adaugare) VALUES (8, 'SMS Pay', 'Inactiv', SYSDATE);
INSERT INTO Metoda_Plata (ID_Metoda, Tip_plata, Status, Data_adaugare) VALUES (9, 'PayPal', 'Activ', SYSDATE);
INSERT INTO Metoda_Plata (ID_Metoda, Tip_plata, Status, Data_adaugare) VALUES (10, 'Western Union', 'Inactiv', SYSDATE);


--Categorie
INSERT INTO Categorie (ID_Categorie, Nume_Categorie, Status) VALUES (1, 'Bauturi pe baza de espresso', 'Activ');
INSERT INTO Categorie (ID_Categorie, Nume_Categorie, Status) VALUES (2, 'Bauturi reci (Ice Coffee)', 'Activ');
INSERT INTO Categorie (ID_Categorie, Nume_Categorie, Status) VALUES (3, 'Ceaiuri', 'Activ');
INSERT INTO Categorie (ID_Categorie, Nume_Categorie, Status) VALUES (4, 'Patiserie', 'Activ');
INSERT INTO Categorie (ID_Categorie, Nume_Categorie, Status) VALUES (5, 'Sandvisuri', 'Activ');
INSERT INTO Categorie (ID_Categorie, Nume_Categorie, Status) VALUES (6, 'Bauturi non-alcoolice', 'Activ');
INSERT INTO Categorie (ID_Categorie, Nume_Categorie, Status) VALUES (7, 'Boabe de cafea (Retail)', 'Activ');


--Locatie
INSERT INTO Locatie (ID_Locatie, Strada, Numar_Strada, Oras, Cod_Postal) VALUES (1, 'Calea Victoriei', '45', 'Bucuresti', '010061');
INSERT INTO Locatie (ID_Locatie, Strada, Numar_Strada, Oras, Cod_Postal) VALUES (2, 'Bulevardul Dacia', '12', 'Bucuresti', '020051');
INSERT INTO Locatie (ID_Locatie, Strada, Numar_Strada, Oras, Cod_Postal) VALUES (3, 'Strada Republicii', '8', 'Brasov', '500030');
INSERT INTO Locatie (ID_Locatie, Strada, Numar_Strada, Oras, Cod_Postal) VALUES (4, 'Piata Sfatului', '15', 'Brasov', '500031');
INSERT INTO Locatie (ID_Locatie, Strada, Numar_Strada, Oras, Cod_Postal) VALUES (5, 'Strada Alexandru Ioan Cuza', '10', 'Craiova', '200585');
INSERT INTO Locatie (ID_Locatie, Strada, Numar_Strada, Oras, Cod_Postal) VALUES (6, 'Piata Unirii', '20', 'Cluj-Napoca', '400098');
INSERT INTO Locatie (ID_Locatie, Strada, Numar_Strada, Oras, Cod_Postal) VALUES (7, 'Bulevardul Eroilor', '5', 'Cluj-Napoca', '400129');
INSERT INTO Locatie (ID_Locatie, Strada, Numar_Strada, Oras, Cod_Postal) VALUES (8, 'Piata Victoriei', '18', 'Timisoara', '300006');
INSERT INTO Locatie (ID_Locatie, Strada, Numar_Strada, Oras, Cod_Postal) VALUES (9, 'Bulevardul Vasile Parvan', '11', 'Timisoara', '300223');
INSERT INTO Locatie (ID_Locatie, Strada, Numar_Strada, Oras, Cod_Postal) VALUES (10, 'Strada Stefan cel Mare', '2', 'Iasi', '700028');


--Magazin (Cafenele)
INSERT INTO Magazin (ID_Magazin, Nume_Magazin, Telefon, ID_Locatie) VALUES (1, 'Brew & Bloom Victoriei', '0721000111', 1);
INSERT INTO Magazin (ID_Magazin, Nume_Magazin, Telefon, ID_Locatie) VALUES (2, 'Brew & Bloom Dacia', '0721000222', 2);
INSERT INTO Magazin (ID_Magazin, Nume_Magazin, Telefon, ID_Locatie) VALUES (3, 'Brew & Bloom Republicii', '0721000333', 3);
INSERT INTO Magazin (ID_Magazin, Nume_Magazin, Telefon, ID_Locatie) VALUES (4, 'Brew & Bloom Sfatului', '0721000444', 4);
INSERT INTO Magazin (ID_Magazin, Nume_Magazin, Telefon, ID_Locatie) VALUES (5, 'Brew & Bloom Cuza', '0721000555', 5);
INSERT INTO Magazin (ID_Magazin, Nume_Magazin, Telefon, ID_Locatie) VALUES (6, 'Brew & Bloom Unirii', '0721000666', 6);
INSERT INTO Magazin (ID_Magazin, Nume_Magazin, Telefon, ID_Locatie) VALUES (7, 'Brew & Bloom Eroilor', '0721000777', 7);
INSERT INTO Magazin (ID_Magazin, Nume_Magazin, Telefon, ID_Locatie) VALUES (8, 'Brew & Bloom Victoriei TM', '0721000888', 8);
INSERT INTO Magazin (ID_Magazin, Nume_Magazin, Telefon, ID_Locatie) VALUES (9, 'Brew & Bloom Parvan', '0721000999', 9);
INSERT INTO Magazin (ID_Magazin, Nume_Magazin, Telefon, ID_Locatie) VALUES (10, 'Brew & Bloom Stefan', '0721000000', 10);


--Angajat (Barista & Staff)
INSERT INTO Angajat (ID_Angajat, Nume, Prenume, Email, Telefon, Salariu, ID_Magazin) VALUES (100, 'Popa', 'Andrei', 'andrei.popa@brewbloomcaffe.ro', '0733111222', 3800.00, 1);
INSERT INTO Angajat (ID_Angajat, Nume, Prenume, Email, Telefon, Salariu, ID_Magazin) VALUES (101, 'Radu', 'Ioana', 'ioana.radu@brewbloomcaffe.ro', '0733222333', 3500.00, 1);
INSERT INTO Angajat (ID_Angajat, Nume, Prenume, Email, Telefon, Salariu, ID_Magazin) VALUES (102, 'Barbu', 'Mihai', 'mihai.barbu@brewbloomcaffe.ro', '0733333444', 3600.00, 2);
INSERT INTO Angajat (ID_Angajat, Nume, Prenume, Email, Telefon, Salariu, ID_Magazin) VALUES (103, 'Sima', 'Elena', 'elena.sima@brewbloomcaffe.ro', '0733444555', 3400.00, 2);
INSERT INTO Angajat (ID_Angajat, Nume, Prenume, Email, Telefon, Salariu, ID_Magazin) VALUES (104, 'Manea', 'Lucian', 'lucian.manea@brewbloomcaffe.ro', '0733555666', 3700.00, 3);
INSERT INTO Angajat (ID_Angajat, Nume, Prenume, Email, Telefon, Salariu, ID_Magazin) VALUES (105, 'Vlaicu', 'Maria', 'maria.vlaicu@brewbloomcaffe.ro', '0733666777', 3550.00, 3);
INSERT INTO Angajat (ID_Angajat, Nume, Prenume, Email, Telefon, Salariu, ID_Magazin) VALUES (106, 'Dima', 'Cosmin', 'cosmin.dima@brewbloomcaffe.ro', '0733777888', 3650.00, 4);
INSERT INTO Angajat (ID_Angajat, Nume, Prenume, Email, Telefon, Salariu, ID_Magazin) VALUES (107, 'Lungu', 'Alina', 'alina.lungu@brewbloomcaffe.ro', '0733888999', 3400.00, 4);
INSERT INTO Angajat (ID_Angajat, Nume, Prenume, Email, Telefon, Salariu, ID_Magazin) VALUES (108, 'Ene', 'Adrian', 'adrian.ene@brewbloomcaffe.ro', '0733999000', 3800.00, 5);
INSERT INTO Angajat (ID_Angajat, Nume, Prenume, Email, Telefon, Salariu, ID_Magazin) VALUES (109, 'Bucur', 'Simona', 'simona.bucur@brewbloomcaffe.ro', '0733000111', 3500.00, 5);
INSERT INTO Angajat (ID_Angajat, Nume, Prenume, Email, Telefon, Salariu, ID_Magazin) VALUES (110, 'Cretu', 'Daniel', 'daniel.cretu@brewbloomcaffe.ro', '0733111333', 3600.00, 6);
INSERT INTO Angajat (ID_Angajat, Nume, Prenume, Email, Telefon, Salariu, ID_Magazin) VALUES (111, 'Gavrila', 'Florina', 'florina.gavrila@brewbloomcaffe.ro', '0733222444', 3450.00, 6);
INSERT INTO Angajat (ID_Angajat, Nume, Prenume, Email, Telefon, Salariu, ID_Magazin) VALUES (112, 'Sandu', 'Ionut', 'ionut.sandu@brewbloomcaffe.ro', '0733333555', 3750.00, 7);
INSERT INTO Angajat (ID_Angajat, Nume, Prenume, Email, Telefon, Salariu, ID_Magazin) VALUES (113, 'Toma', 'Vasilica', 'vasilica.toma@brewbloomcaffe.ro', '0733444666', 3400.00, 7);
INSERT INTO Angajat (ID_Angajat, Nume, Prenume, Email, Telefon, Salariu, ID_Magazin) VALUES (114, 'Dinu', 'Anca', 'anca.dinu@brewbloomcaffe.ro', '0733555777', 3500.00, 8);
INSERT INTO Angajat (ID_Angajat, Nume, Prenume, Email, Telefon, Salariu, ID_Magazin) VALUES (115, 'Mitu', 'Marian', 'marian.mitu@brewbloomcaffe.ro', '0733666888', 3300.00, 8);
INSERT INTO Angajat (ID_Angajat, Nume, Prenume, Email, Telefon, Salariu, ID_Magazin) VALUES (116, 'Voicu', 'Elena', 'elena.voicu@brewbloomcaffe.ro', '0733777999', 3600.00, 9);
INSERT INTO Angajat (ID_Angajat, Nume, Prenume, Email, Telefon, Salariu, ID_Magazin) VALUES (117, 'Marin', 'Iulian', 'iulian.marin@brewbloomcaffe.ro', '0733888000', 3450.00, 9);
INSERT INTO Angajat (ID_Angajat, Nume, Prenume, Email, Telefon, Salariu, ID_Magazin) VALUES (118, 'Ilie', 'Florentina', 'florentina.ilie@brewbloomcaffe.ro', '0733999111', 3400.00, 10);
INSERT INTO Angajat (ID_Angajat, Nume, Prenume, Email, Telefon, Salariu, ID_Magazin) VALUES (119, 'Petre', 'Razvan', 'razvan.petre@brewbloomcaffe.ro', '0733000222', 3350.00, 10);

 
--Produs
INSERT INTO Produs (ID_Produs, Nume_Produs, Pret, ID_Categorie) VALUES (101, 'Espresso Scurt', 9.00, 1);
INSERT INTO Produs (ID_Produs, Nume_Produs, Pret, ID_Categorie) VALUES (102, 'Cappuccino', 14.00, 1);
INSERT INTO Produs (ID_Produs, Nume_Produs, Pret, ID_Categorie) VALUES (103, 'Flat White', 16.00, 1);

INSERT INTO Produs (ID_Produs, Nume_Produs, Pret, ID_Categorie) VALUES (201, 'Iced Latte', 17.00, 2);
INSERT INTO Produs (ID_Produs, Nume_Produs, Pret, ID_Categorie) VALUES (202, 'Cold Brew', 18.00, 2);
INSERT INTO Produs (ID_Produs, Nume_Produs, Pret, ID_Categorie) VALUES (203, 'Frappe cu Vanilie', 19.00, 2);

INSERT INTO Produs (ID_Produs, Nume_Produs, Pret, ID_Categorie) VALUES (301, 'Ceai Verde', 12.00, 3);
INSERT INTO Produs (ID_Produs, Nume_Produs, Pret, ID_Categorie) VALUES (302, 'Ceai de Fructe de Padure', 12.00, 3);
INSERT INTO Produs (ID_Produs, Nume_Produs, Pret, ID_Categorie) VALUES (303, 'Matcha Latte', 18.00, 3);

INSERT INTO Produs (ID_Produs, Nume_Produs, Pret, ID_Categorie) VALUES (401, 'Croissant cu Unt', 8.00, 4);
INSERT INTO Produs (ID_Produs, Nume_Produs, Pret, ID_Categorie) VALUES (402, 'Pain au Chocolat', 10.00, 4);
INSERT INTO Produs (ID_Produs, Nume_Produs, Pret, ID_Categorie) VALUES (403, 'Banana Bread', 12.00, 4);

INSERT INTO Produs (ID_Produs, Nume_Produs, Pret, ID_Categorie) VALUES (501, 'Sandvis cu Pui si Pesto', 22.00, 5);
INSERT INTO Produs (ID_Produs, Nume_Produs, Pret, ID_Categorie) VALUES (502, 'Sandvis Caprese', 20.00, 5);
INSERT INTO Produs (ID_Produs, Nume_Produs, Pret, ID_Categorie) VALUES (503, 'Wrap cu Somon', 25.00, 5);

INSERT INTO Produs (ID_Produs, Nume_Produs, Pret, ID_Categorie) VALUES (601, 'Apa Plata 500ml', 6.00, 6);
INSERT INTO Produs (ID_Produs, Nume_Produs, Pret, ID_Categorie) VALUES (602, 'Limonada cu Menta', 15.00, 6);
INSERT INTO Produs (ID_Produs, Nume_Produs, Pret, ID_Categorie) VALUES (603, 'Fresh de Portocale', 16.00, 6);

INSERT INTO Produs (ID_Produs, Nume_Produs, Pret, ID_Categorie) VALUES (701, 'Cafea Boabe Ethiopia 250g', 45.00, 7);
INSERT INTO Produs (ID_Produs, Nume_Produs, Pret, ID_Categorie) VALUES (702, 'Cafea Boabe Colombia 250g', 42.00, 7);
INSERT INTO Produs (ID_Produs, Nume_Produs, Pret, ID_Categorie) VALUES (703, 'Cani personalizate', 35.00, 7);


--Stoc
INSERT INTO Stoc (ID_Produs, ID_Magazin, Cantitate, Stare_Stoc) VALUES (101, 1, 100, 'Disponibil');
INSERT INTO Stoc (ID_Produs, ID_Magazin, Cantitate, Stare_Stoc) VALUES (401, 1, 30, 'Disponibil');
INSERT INTO Stoc (ID_Produs, ID_Magazin, Cantitate, Stare_Stoc) VALUES (701, 1, 10, 'Disponibil');
INSERT INTO Stoc (ID_Produs, ID_Magazin, Cantitate, Stare_Stoc) VALUES (102, 2, 80, 'Disponibil');
INSERT INTO Stoc (ID_Produs, ID_Magazin, Cantitate, Stare_Stoc) VALUES (402, 2, 5, 'Stoc redus');
INSERT INTO Stoc (ID_Produs, ID_Magazin, Cantitate, Stare_Stoc) VALUES (602, 2, 25, 'Disponibil');
INSERT INTO Stoc (ID_Produs, ID_Magazin, Cantitate, Stare_Stoc) VALUES (201, 3, 50, 'Disponibil');
INSERT INTO Stoc (ID_Produs, ID_Magazin, Cantitate, Stare_Stoc) VALUES (501, 3, 15, 'Disponibil');
INSERT INTO Stoc (ID_Produs, ID_Magazin, Cantitate, Stare_Stoc) VALUES (103, 3, 60, 'Disponibil');
INSERT INTO Stoc (ID_Produs, ID_Magazin, Cantitate, Stare_Stoc) VALUES (301, 4, 40, 'Disponibil');
INSERT INTO Stoc (ID_Produs, ID_Magazin, Cantitate, Stare_Stoc) VALUES (403, 4, 8, 'Stoc redus');
INSERT INTO Stoc (ID_Produs, ID_Magazin, Cantitate, Stare_Stoc) VALUES (601, 4, 50, 'Disponibil');
INSERT INTO Stoc (ID_Produs, ID_Magazin, Cantitate, Stare_Stoc) VALUES (202, 5, 30, 'Disponibil');
INSERT INTO Stoc (ID_Produs, ID_Magazin, Cantitate, Stare_Stoc) VALUES (502, 5, 2, 'Stoc redus');
INSERT INTO Stoc (ID_Produs, ID_Magazin, Cantitate, Stare_Stoc) VALUES (702, 5, 12, 'Disponibil');
INSERT INTO Stoc (ID_Produs, ID_Magazin, Cantitate, Stare_Stoc) VALUES (101, 6, 90, 'Disponibil');
INSERT INTO Stoc (ID_Produs, ID_Magazin, Cantitate, Stare_Stoc) VALUES (603, 6, 20, 'Disponibil');
INSERT INTO Stoc (ID_Produs, ID_Magazin, Cantitate, Stare_Stoc) VALUES (302, 6, 35, 'Disponibil');
INSERT INTO Stoc (ID_Produs, ID_Magazin, Cantitate, Stare_Stoc) VALUES (102, 7, 75, 'Disponibil');
INSERT INTO Stoc (ID_Produs, ID_Magazin, Cantitate, Stare_Stoc) VALUES (401, 7, 10, 'Disponibil');
INSERT INTO Stoc (ID_Produs, ID_Magazin, Cantitate, Stare_Stoc) VALUES (703, 7, 15, 'Disponibil');
INSERT INTO Stoc (ID_Produs, ID_Magazin, Cantitate, Stare_Stoc) VALUES (203, 8, 45, 'Disponibil');
INSERT INTO Stoc (ID_Produs, ID_Magazin, Cantitate, Stare_Stoc) VALUES (503, 8, 5, 'Stoc redus');
INSERT INTO Stoc (ID_Produs, ID_Magazin, Cantitate, Stare_Stoc) VALUES (303, 8, 25, 'Disponibil');
INSERT INTO Stoc (ID_Produs, ID_Magazin, Cantitate, Stare_Stoc) VALUES (103, 9, 65, 'Disponibil');
INSERT INTO Stoc (ID_Produs, ID_Magazin, Cantitate, Stare_Stoc) VALUES (402, 9, 12, 'Disponibil');
INSERT INTO Stoc (ID_Produs, ID_Magazin, Cantitate, Stare_Stoc) VALUES (602, 9, 22, 'Disponibil');
INSERT INTO Stoc (ID_Produs, ID_Magazin, Cantitate, Stare_Stoc) VALUES (101, 10, 85, 'Disponibil');
INSERT INTO Stoc (ID_Produs, ID_Magazin, Cantitate, Stare_Stoc) VALUES (501, 10, 3, 'Stoc redus');
INSERT INTO Stoc (ID_Produs, ID_Magazin, Cantitate, Stare_Stoc) VALUES (701, 10, 8, 'Disponibil');


--Comanda
INSERT INTO Comanda (ID_Comanda, Data_Plasarii, Total, CNP, ID_Metoda) VALUES (1, TO_DATE('2024-12-01', 'YYYY-MM-DD'), 45.00, '2800129076532', 1);
INSERT INTO Comanda (ID_Comanda, Data_Plasarii, Total, CNP, ID_Metoda) VALUES (2, TO_DATE('2024-12-02', 'YYYY-MM-DD'), 24.00, '5050923075141', 2);
INSERT INTO Comanda (ID_Comanda, Data_Plasarii, Total, CNP, ID_Metoda) VALUES (3, TO_DATE('2024-12-03', 'YYYY-MM-DD'), 36.00, '2990529077520', 4);
INSERT INTO Comanda (ID_Comanda, Data_Plasarii, Total, CNP, ID_Metoda) VALUES (4, TO_DATE('2024-12-04', 'YYYY-MM-DD'), 15.00, '5051015075959', 6);
INSERT INTO Comanda (ID_Comanda, Data_Plasarii, Total, CNP, ID_Metoda) VALUES (5, TO_DATE('2024-12-05', 'YYYY-MM-DD'), 28.00, '2602042907564', 5);
INSERT INTO Comanda (ID_Comanda, Data_Plasarii, Total, CNP, ID_Metoda) VALUES (6, TO_DATE('2024-12-06', 'YYYY-MM-DD'), 30.00, '5020619074364', 9);
INSERT INTO Comanda (ID_Comanda, Data_Plasarii, Total, CNP, ID_Metoda) VALUES (7, TO_DATE('2024-12-07', 'YYYY-MM-DD'), 21.00, '6050411074101', 1);
INSERT INTO Comanda (ID_Comanda, Data_Plasarii, Total, CNP, ID_Metoda) VALUES (8, TO_DATE('2024-12-08', 'YYYY-MM-DD'), 40.00, '5241225073610', 4);
INSERT INTO Comanda (ID_Comanda, Data_Plasarii, Total, CNP, ID_Metoda) VALUES (9, TO_DATE('2024-12-09', 'YYYY-MM-DD'), 37.00, '6050623078797', 6);
INSERT INTO Comanda (ID_Comanda, Data_Plasarii, Total, CNP, ID_Metoda) VALUES (10, TO_DATE('2024-12-10', 'YYYY-MM-DD'), 22.00, '1970725070980', 2);

--Detalii_Comanda
INSERT INTO Detalii_Comanda (ID_Comanda, ID_Produs, Cantitate, Pret_Unitar) VALUES (1, 102, 2, 14.00);
INSERT INTO Detalii_Comanda (ID_Comanda, ID_Produs, Cantitate, Pret_Unitar) VALUES (1, 201, 1, 17.00);
INSERT INTO Detalii_Comanda (ID_Comanda, ID_Produs, Cantitate, Pret_Unitar) VALUES (2, 401, 3, 8.00);
INSERT INTO Detalii_Comanda (ID_Comanda, ID_Produs, Cantitate, Pret_Unitar) VALUES (3, 103, 1, 16.00);
INSERT INTO Detalii_Comanda (ID_Comanda, ID_Produs, Cantitate, Pret_Unitar) VALUES (3, 502, 1, 20.00);
INSERT INTO Detalii_Comanda (ID_Comanda, ID_Produs, Cantitate, Pret_Unitar) VALUES (4, 602, 1, 15.00);
INSERT INTO Detalii_Comanda (ID_Comanda, ID_Produs, Cantitate, Pret_Unitar) VALUES (5, 403, 1, 12.00);
INSERT INTO Detalii_Comanda (ID_Comanda, ID_Produs, Cantitate, Pret_Unitar) VALUES (5, 103, 1, 16.00);

--Verificari
SELECT * FROM Client;

SELECT p.ID_Produs, p.Nume_Produs, p.Pret, c.Nume_Categorie 
FROM Produs p
JOIN Categorie c ON p.ID_Categorie = c.ID_Categorie;

SELECT com.ID_Comanda, com.Data_Plasarii, com.Total, cli.Nume, cli.Prenume 
FROM Comanda com
JOIN Client cli ON com.CNP = cli.CNP;

SELECT m.Nume_Magazin, p.Nume_Produs, s.Cantitate, s.Stare_Stoc
FROM Stoc s
JOIN Magazin m ON s.ID_Magazin = m.ID_Magazin
JOIN Produs p ON s.ID_Produs = p.ID_Produs
WHERE m.ID_Magazin = 1;

SELECT m.Nume_Magazin, COUNT(a.ID_Angajat) AS Numar_Angajati
FROM Angajat a
JOIN Magazin m ON a.ID_Magazin = m.ID_Magazin
GROUP BY m.Nume_Magazin;

COMMIT;


-- VIZUALIZARI


-- 1. Vizualizare compusa 
CREATE OR REPLACE VIEW V_PRODUS_CATEGORIE AS
SELECT p.ID_Produs, p.Nume_Produs, p.Pret, p.ID_Categorie
FROM Produs p
JOIN Categorie c ON p.ID_Categorie = c.ID_Categorie;

-- 2. Vizualizare complexa 
CREATE OR REPLACE VIEW V_STATISTICI_MAGAZINE AS
SELECT m.ID_Magazin, m.Nume_Magazin, l.Oras,
       COUNT(a.ID_Angajat) AS Numar_Angajati,
       NVL(ROUND(AVG(a.Salariu), 2), 0) AS Salariu_Mediu,
       NVL(SUM(a.Salariu), 0) AS Fond_Total_Salarii
FROM Magazin m
JOIN Locatie l ON m.ID_Locatie = l.ID_Locatie
LEFT JOIN Angajat a ON m.ID_Magazin = a.ID_Magazin
GROUP BY m.ID_Magazin, m.Nume_Magazin, l.Oras;

COMMIT;