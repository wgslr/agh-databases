CREATE OR REPLACE TYPE osoby_wycieczki_r AS object (
  kraj            VARCHAR(50),
  "data"          DATE,
  nazwa_wycieczki VARCHAR(100),
  imie            VARCHAR2(50),
  nazwisko        VARCHAR2(50),
  status          CHAR(1)
);


CREATE OR REPLACE TYPE osoby_wycieczki_t IS TABLE OF osoby_wycieczki_r;

-- @fixme validate wycieczka exists

CREATE OR REPLACE
FUNCTION uczestnicy_wycieczki(id INT)
  return osoby_wycieczki_t as v_ret osoby_wycieczki_t;

  BEGIN
    SELECT osoby_wycieczki_r(w.KRAJ, w.DATA, w.NAZWA, o.IMIE,
                                               o.NAZWISKO, r.STATUS)
    BULK COLLECT INTO v_ret
    FROM WYCIECZKI w
           JOIN REZERWACJE r ON w.ID_WYCIECZKI = r.ID_WYCIECZKI
           JOIN OSOBY o ON r.ID_OSOBY = o.ID_OSOBY;
    return v_ret;
  end uczestnicy_wycieczki;


SELECT *
FROM uczestnicy_wycieczki(3);


SELECT *
FROM WYCIECZKI