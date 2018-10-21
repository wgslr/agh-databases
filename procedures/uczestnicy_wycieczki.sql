CREATE OR REPLACE TYPE osoby_ret AS object (
  nazwa VARCHAR(100),
  kraj  VARCHAR(50)
);

CREATE OR REPLACE TYPE osoby_ret_T as table OF osoby_ret;

CREATE OR REPLACE
FUNCTION uczestnicy_wycieczki(id INT)
  return osoby_ret_T as
  v_ret osoby_ret_T;
  BEGIN
    v_ret := (SELECT --w.ID_WYCIECZKI,
                   w.NAZWA, w.KRAJ --,
        --                    w.DATA,
        --                    o.IMIE,
        --                    o.NAZWISKO,
        --                    r.STATUS
            FROM WYCIECZKI w
                   JOIN REZERWACJE r ON w.ID_WYCIECZKI = r.ID_WYCIECZKI
                   JOIN OSOBY o ON r.ID_OSOBY = o.ID_OSOBY
            WHERE w.ID_WYCIECZKI = id);
    return v_ret;
  end uczestnicy_wycieczki;
