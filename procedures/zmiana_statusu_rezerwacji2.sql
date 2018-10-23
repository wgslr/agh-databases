CREATE OR REPLACE PROCEDURE
  zmiana_statusu_rezerwacji2(id_rezerwacji REZERWACJE.NR_REZERWACJI%TYPE,
                             nowy_status   REZERWACJE.STATUS%TYPE) AS
  stary_status REZERWACJE.STATUS%TYPE;
  istnieje     integer;
  BEGIN
    SELECT COUNT(*) INTO istnieje
    FROM WYCIECZKI_PRZYSZLE wp
           JOIN REZERWACJE r ON r.ID_WYCIECZKI = wp.ID_WYCIECZKI
    WHERE r.NR_REZERWACJI = id_rezerwacji;
    IF istnieje = 0
    THEN
      raise_application_error(-20102,
                              'Status rezerwacji można zmieniać tylko dla wycieczek w przyszłości');
    end if;

    SELECT status INTO stary_status
    FROM REZERWACJE
    WHERE NR_REZERWACJI = id_rezerwacji;

    CASE
      WHEN stary_status IS NULL
      THEN
        raise_application_error(-20100, 'Rezerwacja nie istnieje');

      WHEN nowy_status = 'N'
      THEN
        raise_application_error(-20103,
                                'Istniejąca rezerwacja nie może stać się nowa');


      WHEN stary_status = 'A'
      THEN
        SELECT COUNT(*) INTO istnieje
        FROM DOSTEPNE_WYCIECZKI_VIEW2 dwv
               JOIN REZERWACJE r ON r.ID_WYCIECZKI = dwv.ID_WYCIECZKI
        WHERE r.NR_REZERWACJI = id_rezerwacji;

        IF istnieje = 0
        THEN
          raise_application_error(-20101,
                                  'Brak miejsc dla przywrócenia anulowanej rezerwacji');
        END IF;

    ELSE
      UPDATE REZERWACJE
      SET STATUS = nowy_status
      WHERE NR_REZERWACJI = id_rezerwacji;

      UPDATE WYCIECZKI w
      SET LICZBA_WOLNYCH_MIEJSC = LICZBA_WOLNYCH_MIEJSC - 1
      WHERE w.ID_WYCIECZKI = (SELECT ID_WYCIECZKI
                              FROM REZERWACJE r
                              WHERE r.NR_REZERWACJI = id_rezerwacji);

      INSERT INTO REZERWACJE_LOG (ID_REZERWACJI, DATA, STATUS)
      VALUES (id_rezerwacji, CURRENT_DATE, nowy_status);
    END CASE;

  END zmiana_statusu_rezerwacji2;

