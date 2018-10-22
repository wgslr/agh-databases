CREATE OR REPLACE VIEW wycieczki_miejsca
  AS
    SELECT w.ID_WYCIECZKI,
           w.kraj,
           w.data,
           w.nazwa,
           w.liczba_miejsc,
           w.liczba_miejsc - COUNT(DISTINCT r.ID_OSOBY) as liczba_wolnych_miejsc
    FROM wycieczki w
           LEFT JOIN (SELECT * FROM REZERWACJE WHERE status <> 'A') r ON r.ID_WYCIECZKI = w.ID_WYCIECZKI
    GROUP BY w.ID_WYCIECZKI, w.kraj, w.data, w.nazwa, w.LICZBA_MIEJSC;
