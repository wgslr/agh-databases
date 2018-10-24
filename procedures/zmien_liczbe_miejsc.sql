CREATE OR REPLACE PROCEDURE zmien_liczbe_miejsc(
  id_w         WYCIECZKI.ID_WYCIECZKI%TYPE,
  nowe_miejsca WYCIECZKI.LICZBA_MIEJSC%TYPE) AS
  zajete integer;
  BEGIN
    -- throws NO_DATA_ERROR if wycieczka doesn't exist
    SELECT LICZBA_MIEJSC - LICZBA_WOLNYCH_MIEJSC INTO zajete
    FROM WYCIECZKI_MIEJSCA wm
    WHERE wm.ID_WYCIECZKI = id_w;

    IF nowe_miejsca < 0 OR zajete > nowe_miejsca
    THEN
      raise_application_error(-20006, 'Nowa liczba miejsc zbyt niska');
    end if;

    UPDATE WYCIECZKI
    SET LICZBA_MIEJSC = nowe_miejsca
    WHERE ID_WYCIECZKI = id_w;
  END;
