CREATE OR REPLACE VIEW dostepne_wycieczki_view
  AS
    SELECT w.kraj, w.data, w.nazwa, w.liczba_miejsc, w.liczba_wolnych_miejsc
    FROM wycieczki_miejsca w
    WHERE liczba_wolnych_miejsc > 0
      AND w.DATA > CURRENT_DATE;
