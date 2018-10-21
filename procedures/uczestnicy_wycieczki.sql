CREATE OR REPLACE TYPE osoby_record AS object (
  nazwa VARCHAR(100),
  kraj  VARCHAR(50)
);

CREATE OR REPLACE TYPE osoby_table as table OF osoby_record;

CREATE OR REPLACE
FUNCTION uczestnicy_wycieczki --(id INT)
  return osoby_table as
  v_ret osoby_table;
  BEGIN
    v_ret := osoby_table();
    v_ret.extend; v_ret(v_ret.count) := osoby_record('Makabra', 'Transylwania');
--     v_ret := (SELECT --w.ID_WYCIECZKI,
--                    w.NAZWA, w.KRAJ --,
--         --                    w.DATA,
--         --                    o.IMIE,
--         --                    o.NAZWISKO,
--         --                    r.STATUS
--             FROM WYCIECZKI w
--                    JOIN REZERWACJE r ON w.ID_WYCIECZKI = r.ID_WYCIECZKI
--                    JOIN OSOBY o ON r.ID_OSOBY = o.ID_OSOBY
--             WHERE w.ID_WYCIECZKI = id);
    return v_ret;
  end uczestnicy_wycieczki;

  DROP FUNCTION UCZESTNICY_WYCIECZKI