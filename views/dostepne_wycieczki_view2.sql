CREATE OR REPLACE VIEW dostepne_wycieczki_view2
  AS
    SELECT w.id_wycieczki, w.kraj, w.data, w.nazwa, w.liczba_miejsc, w.liczba_wolnych_miejsc
    FROM WYCIECZKI w
    WHERE liczba_wolnych_miejsc > 0
      AND w.DATA > CURRENT_DATE;
