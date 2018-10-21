DROP TABLE REZERWACJE
DROP TABLE osoby;
drop table WYCIECZKI;

--TABLES
CREATE TABLE OSOBY
(
  ID_OSOBY INT GENERATED ALWAYS AS IDENTITY NOT NULL
  ,
  IMIE     VARCHAR2(50)
  ,
  NAZWISKO VARCHAR2(50)
  ,
  PESEL    VARCHAR2(11)
  ,
  KONTAKT  VARCHAR2(100)
  ,
  CONSTRAINT OSOBY_PK PRIMARY KEY
    (
      ID_OSOBY
    )
  ENABLE
);
CREATE TABLE WYCIECZKI
(
  ID_WYCIECZKI  INT GENERATED ALWAYS AS IDENTITY NOT NULL
  ,
  NAZWA         VARCHAR2(100)
  ,
  KRAJ          VARCHAR2(50)
  ,
  DATA          DATE
  ,
  OPIS          VARCHAR2(200)
  ,
  LICZBA_MIEJSC INT
  ,
  CONSTRAINT WYCIECZKI_PK PRIMARY KEY
    (
      ID_WYCIECZKI
    )
  ENABLE
);
CREATE TABLE REZERWACJE
(
  NR_REZERWACJI INT GENERATED ALWAYS AS IDENTITY NOT NULL
  ,
  ID_WYCIECZKI  INT
  ,
  ID_OSOBY      INT
  ,
  STATUS        CHAR(1)
  ,
  CONSTRAINT REZERWACJE_PK PRIMARY KEY
    (
      NR_REZERWACJI
    )
  ENABLE
);
ALTER TABLE REZERWACJE
  ADD CONSTRAINT REZERWACJE_FK1 FOREIGN KEY
  (
    ID_OSOBY
  )
REFERENCES OSOBY
  (
    ID_OSOBY
  )
ENABLE;
ALTER TABLE REZERWACJE
  ADD CONSTRAINT REZERWACJE_FK2 FOREIGN KEY
  (
    ID_WYCIECZKI
  )
REFERENCES WYCIECZKI
  (
    ID_WYCIECZKI
  )
ENABLE;
ALTER TABLE REZERWACJE
  ADD CONSTRAINT REZERWACJE_CHK1 CHECK
(status IN ('N', 'P', 'Z', 'A'))
ENABLE;


INSERT INTO osoby (imie, nazwisko, pesel, kontakt)
VALUES ('Adam', 'Kowalski', '87654321', 'tel: 6623');
INSERT INTO osoby (imie, nazwisko, pesel, kontakt)
VALUES ('Jan', 'Nowak', '12345678', 'tel: 2312, dzwonić po 18.00');

INSERT INTO osoby (imie, nazwisko, pesel, kontakt)
VALUES ('Janek', 'Nowaczek', '12345678', 'tel: 2312, dzwonić po 18.00')
INSERT INTO osoby (imie, nazwisko, pesel, kontakt)
VALUES ('Pawel', 'Matuszek', '12345678', 'tel: 2312, dzwonić po 18.00');

INSERT INTO osoby (imie, nazwisko, pesel, kontakt)
VALUES ('Matesz', 'Drwal', '12345678', 'tel: 2312, dzwonić po 13.00');
INSERT INTO osoby (imie, nazwisko, pesel, kontakt)
VALUES ('Eustachy', 'Jozek', '12345678', 'tel: 2312, dzwonić po 13.00');
INSERT INTO osoby (imie, nazwisko, pesel, kontakt)
VALUES ('Janek', 'ANowaczek', '12345678', 'tel: 2312, dzwonić po 18.00');
INSERT INTO osoby (imie, nazwisko, pesel, kontakt)
VALUES ('Pawel', 'AMatuszek', '12345678', 'tel: 2312, dzwonić po 18.00');
INSERT INTO osoby (imie, nazwisko, pesel, kontakt)
VALUES ('Matesz', 'ADrwal', '12345678', 'tel: 2312, dzwonić po 13.00');
INSERT INTO osoby (imie, nazwisko, pesel, kontakt)
VALUES ('Eustachy', 'AJozek', '12345678', 'tel: 2312, dzwonić po 13.00');

INSERT INTO wycieczki (nazwa, kraj, data, opis, liczba_miejsc)
VALUES ('Wycieczka do Paryza', 'Francja', TO_DATE('2016-01-01', 'YYYY-MM-DD'), 'Ciekawa wycieczka ...', 3);
INSERT INTO wycieczki (nazwa, kraj, data, opis, liczba_miejsc)
VALUES ('Piękny Kraków', 'Polska', TO_DATE('2017-02-03', 'YYYY-MM-DD'), 'Najciekawa wycieczka ...', 2);
INSERT INTO wycieczki (nazwa, kraj, data, opis, liczba_miejsc)
VALUES ('Wieliczka', 'Polska', TO_DATE('2017-03-03', 'YYYY-MM-DD'), 'Zadziwiająca kopalnia ...', 2);
--UWAGA
--W razie problemów z formatem daty można użyć funkcji TO_DATE
INSERT INTO wycieczki (nazwa, kraj, data, opis, liczba_miejsc)
VALUES ('Wieliczka2', 'Polska', TO_DATE('2019-03-03', 'YYYY-MM-DD'), 'Zadziwiająca kopalnia ...', 2);
INSERT INTO rezerwacje (id_wycieczki, id_osoby, status)
VALUES (1, 1, 'N');
INSERT INTO rezerwacje (id_wycieczki, id_osoby, status)
VALUES (2, 2, 'P');
INSERT INTO rezerwacje (id_wycieczki, id_osoby, status)
VALUES (3, 3, 'P');
INSERT INTO rezerwacje (id_wycieczki, id_osoby, status)
VALUES (4, 4, 'N');
INSERT INTO rezerwacje (id_wycieczki, id_osoby, status)
VALUES (1, 5, 'N');
INSERT INTO rezerwacje (id_wycieczki, id_osoby, status)
VALUES (2, 6, 'P');
INSERT INTO rezerwacje (id_wycieczki, id_osoby, status)
VALUES (3, 7, 'P');
INSERT INTO rezerwacje (id_wycieczki, id_osoby, status)
VALUES (4, 8, 'P');
INSERT INTO rezerwacje (id_wycieczki, id_osoby, status)
VALUES (1, 9, 'P');
INSERT INTO rezerwacje (id_wycieczki, id_osoby, status)
VALUES (2, 10, 'A');


CREATE OR REPLACE VIEW wycieczki_osoby
  AS
    SELECT w.ID_WYCIECZKI, w.NAZWA, w.KRAJ, w.DATA, o.IMIE, o.NAZWISKO, r.STATUS
    FROM WYCIECZKI w
           JOIN REZERWACJE r ON w.ID_WYCIECZKI = r.ID_WYCIECZKI
           JOIN OSOBY o ON r.ID_OSOBY = o.ID_OSOBY;

CREATE OR REPLACE VIEW wycieczki_osoby_potwierdzone
  AS
    SELECT w.ID_WYCIECZKI, w.NAZWA, w.KRAJ, w.DATA, o.IMIE, o.NAZWISKO, r.STATUS
    FROM WYCIECZKI w
           JOIN REZERWACJE r ON w.ID_WYCIECZKI = r.ID_WYCIECZKI
           JOIN OSOBY o ON r.ID_OSOBY = o.ID_OSOBY
    WHERE r.STATUS = 'Z'
       OR r.STATUS = 'P';

CREATE OR REPLACE VIEW wycieczki_przyszle
  AS
    SELECT w.ID_WYCIECZKI, w.NAZWA, w.KRAJ, w.DATA, o.IMIE, o.NAZWISKO, r.STATUS
    FROM WYCIECZKI w
           JOIN REZERWACJE r ON w.ID_WYCIECZKI = r.ID_WYCIECZKI
           JOIN OSOBY o ON r.ID_OSOBY = o.ID_OSOBY
    WHERE w.DATA > CURRENT_DATE

SELECT *
FROM wycieczki_przyszle;

DROP VIEW wycieczki_miejsca;
CREATE OR REPLACE VIEW wycieczki_miejsca
  AS
    SELECT w.kraj,
           w.data,
           w.nazwa,
           w.liczba_miejsc,
           w.liczba_miejsc - COUNT(DISTINCT r.ID_OSOBY) as liczba_wolnych_miejsc
    FROM wycieczki w
           LEFT JOIN (SELECT * FROM REZERWACJE WHERE status <> 'A') r ON r.ID_WYCIECZKI = w.ID_WYCIECZKI
    GROUP BY w.kraj, w.data, w.nazwa, w.LICZBA_MIEJSC;

SELECT *
FROM wycieczki_miejsca;
SELECT *
FROM REZERWACJE;
-- UPDATE REZERWACJE SET STATUS='A' WHERE NR_REZERWACJI = 8

CREATE OR REPLACE VIEW dostepne_wycieczki
  AS
    SELECT w.kraj, w.data, w.nazwa, w.liczba_miejsc, w.liczba_wolnych_miejsc
    FROM wycieczki_miejsca w
    WHERE liczba_wolnych_miejsc > 0
      AND w.DATA > CURRENT_DATE;

SELECT *
FROM dostepne_wycieczki;

DROP VIEW rezerwacje_do_anulowania
CREATE VIEW rezerwacje_do_anulowania
  AS
    SELECT o.IMIE, o.NAZWISKO, r.STATUS, w.NAZWA, w.DATA
    FROM OSOBY o
           JOIN REZERWACJE r ON r.ID_OSOBY = o.ID_OSOBy
           JOIN wycieczki w ON w.ID_WYCIECZKI = r.ID_WYCIECZKI
    WHERE r.STATUS = 'N'
      AND w.DATA < (CURRENT_DATE - 7);

SELECT *
FROM rezerwacje_do_anulowania;


CREATE OR REPLACE
FUNCTION uczestnicy_wycieczki(id INT) RETURN TABLE
BEGIN
  RETURN (SELECT w.ID_WYCIECZKI, w.NAZWA, w.KRAJ, w.DATA, o.IMIE, o.NAZWISKO, r.STATUS
          FROM WYCIECZKI w
                 JOIN REZERWACJE r ON w.ID_WYCIECZKI = r.ID_WYCIECZKI
                 JOIN OSOBY o ON r.ID_OSOBY = o.ID_OSOBY)
  WHERE w.ID_WYCIECZKI = id
end uczestnicy_wycieczki;
