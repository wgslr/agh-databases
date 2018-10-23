INSERT INTO osoby (imie, nazwisko, pesel, kontakt)
VALUES ('Adam', 'Kowalski', '87654321', 'tel: 6623');
INSERT INTO osoby (imie, nazwisko, pesel, kontakt)
VALUES ('Jan', 'Nowak', '12345678', 'tel: 2312, dzwonić po 18.00');
INSERT INTO osoby (imie, nazwisko, pesel, kontakt)
VALUES ('Janek', 'Nowaczek', '87654332', 'fax: 2312');
INSERT INTO osoby (imie, nazwisko, pesel, kontakt)
VALUES ('Pawel', 'Matuszek', '11111111', 'tel: 2412');
INSERT INTO osoby (imie, nazwisko, pesel, kontakt)
VALUES ('Matesz', 'Drwal', '12345678', 'tel: 25121');
INSERT INTO osoby (imie, nazwisko, pesel, kontakt)
VALUES ('Eustachy', 'Jozek', '12345678', 'tel: 23999');
INSERT INTO osoby (imie, nazwisko, pesel, kontakt)
VALUES ('Michał', 'Nowaczek', '12345678', 'tel: 23444');
INSERT INTO osoby (imie, nazwisko, pesel, kontakt)
VALUES ('Robert', 'Matuszek', '12345678', 'tel: 2312');
INSERT INTO osoby (imie, nazwisko, pesel, kontakt)
VALUES ('Ignacy', 'Drwal', '12345678', 'tel: 2312');
INSERT INTO osoby (imie, nazwisko, pesel, kontakt)
VALUES ('Adam', 'Mickiewicz', '12345678', 'tel: 2312');

INSERT INTO wycieczki (nazwa, kraj, data, opis, liczba_miejsc)
VALUES ('Wycieczka do Paryza', 'Francja', TO_DATE('2016-01-01', 'YYYY-MM-DD'), 'Ciekawa wycieczka ...', 3);
INSERT INTO wycieczki (nazwa, kraj, data, opis, liczba_miejsc)
VALUES ('Piękny Kraków', 'Polska', TO_DATE('2017-02-03', 'YYYY-MM-DD'), 'Najciekawa wycieczka ...', 2);
INSERT INTO wycieczki (nazwa, kraj, data, opis, liczba_miejsc)
VALUES ('Wieliczka', 'Polska', TO_DATE('2017-03-03', 'YYYY-MM-DD'), 'Zadziwiająca kopalnia ...', 2);
INSERT INTO wycieczki (nazwa, kraj, data, opis, liczba_miejsc)
VALUES ('Krapkowice', 'Polska', TO_DATE('2019-03-03', 'YYYY-MM-DD'), 'Stare wapienniki...', 2);

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


