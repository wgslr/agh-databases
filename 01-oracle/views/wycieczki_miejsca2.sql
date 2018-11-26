CREATE OR REPLACE VIEW wycieczki_miejsca2
  AS
    SELECT w.ID_WYCIECZKI,
           w.kraj,
           w.data,
           w.nazwa,
           w.liczba_miejsc,
           w.LICZBA_WOLNYCH_MIEJSC
    FROM wycieczki w;
