CREATE VIEW rezerwacje_do_anulowania
  AS
    SELECT o.IMIE, o.NAZWISKO, r.STATUS, w.NAZWA, w.DATA
    FROM OSOBY o
           JOIN REZERWACJE r ON r.ID_OSOBY = o.ID_OSOBy
           JOIN wycieczki w ON w.ID_WYCIECZKI = r.ID_WYCIECZKI
    WHERE r.STATUS = 'N'
      AND w.DATA < (CURRENT_DATE - 7);
