CREATE OR REPLACE PROCEDURE
  dodaj_rezerwacje(id_wycieczki WYCIECZKI.ID_WYCIECZKI%TYPE,
                   id_osoby     OSOBY.ID_OSOBY%TYPE) AS
  istnieje integer;
  BEGIN
    SELECT COUNT(*) INTO istnieje
    FROM OSOBY
    WHERE OSOBY.ID_OSOBY = dodaj_rezerwacje.id_osoby;

    IF istnieje = 0
    THEN
      raise_application_error(-20002, 'Brak osoby o podanym id');
    END IF;

    SELECT COUNT(*) INTO istnieje
    FROM DOSTEPNE_WYCIECZKI_VIEW w
    WHERE w.ID_WYCIECZKI = dodaj_rezerwacje.id_wycieczki;

    IF istnieje = 0
    THEN
      raise_application_error(-20004, 'Brak dostępnej wycieczki o podanym id');
    END IF;

    SELECT COUNT(*) INTO istnieje
    FROM REZERWACJE r
    WHERE r.ID_WYCIECZKI = dodaj_rezerwacje.id_wycieczki
      AND r.ID_OSOBY = dodaj_rezerwacje.id_osoby;

    IF istnieje > 0
    THEN
      raise_application_error(-20005, 'Rezerwacja juz istnieje');
    END IF;

    INSERT INTO REZERWACJE (id_wycieczki, id_osoby, STATUS)
    VALUES (dodaj_rezerwacje.id_wycieczki, dodaj_rezerwacje.id_osoby, 'N');

  END dodaj_rezerwacje;

