CREATE OR REPLACE PROCEDURE
  dodaj_rezerwacje2(id_wycieczki WYCIECZKI.ID_WYCIECZKI%TYPE,
                   id_osoby     OSOBY.ID_OSOBY%TYPE) AS
  istnieje integer;
  nowy_id  integer;
  BEGIN
    SELECT COUNT(*) INTO istnieje
    FROM OSOBY
    WHERE OSOBY.ID_OSOBY = dodaj_rezerwacje2.id_osoby;

    IF istnieje = 0
    THEN
      raise_application_error(-20002, 'Brak osoby o podanym id');
    END IF;

    SELECT COUNT(*) INTO istnieje
    FROM DOSTEPNE_WYCIECZKI_VIEW w
    WHERE w.ID_WYCIECZKI = dodaj_rezerwacje2.id_wycieczki;

    IF istnieje = 0
    THEN
      raise_application_error(-20004, 'Brak dostępnej wycieczki o podanym id');
    END IF;

    SELECT COUNT(*) INTO istnieje
    FROM REZERWACJE r
    WHERE r.ID_WYCIECZKI = dodaj_rezerwacje2.id_wycieczki
      AND r.ID_OSOBY = dodaj_rezerwacje2.id_osoby;

    IF istnieje > 0
    THEN
      raise_application_error(-20005, 'Rezerwacja juz istnieje');
    END IF;

    INSERT INTO REZERWACJE (id_wycieczki, id_osoby, STATUS)
    VALUES (dodaj_rezerwacje2.id_wycieczki, dodaj_rezerwacje2.id_osoby, 'N');

    UPDATE WYCIECZKI
    SET LICZBA_WOLNYCH_MIEJSC = LICZBA_WOLNYCH_MIEJSC - 1
    WHERE ID_WYCIECZKI = dodaj_rezerwacje2.id_wycieczki;

    -- using sequence associated with REZERWACJE.nr_rezerwacji
    SELECT "ISEQ$$_186444".currval INTO nowy_id FROM dual;

    INSERT INTO REZERWACJE_LOG (ID_REZERWACJI, DATA, STATUS)
    VALUES (nowy_id, CURRENT_DATE, 'N');

  END dodaj_rezerwacje2;

