CREATE OR REPLACE PROCEDURE przelicz AS
  BEGIN
    UPDATE WYCIECZKI w
    SET LICZBA_WOLNYCH_MIEJSC = LICZBA_MIEJSC - (SELECT COUNT(*)
                                                 FROM REZERWACJE r
                                                 WHERE r.ID_WYCIECZKI = w.ID_WYCIECZKI
                                                   AND r.STATUS <> 'A');
  END;

  BEGIN
    przelicz();
  end;
