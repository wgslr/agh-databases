CREATE OR REPLACE TYPE wycieczki_r AS object (
  id_wycieczki  NUMBER,
  nazwa         VARCHAR2(100),
  kraj          VARCHAR2(50),
  "data"        DATE,
  opis          VARCHAR2(200),
  liczba_miejsc NUMBER
);


CREATE OR REPLACE TYPE wycieczki_t IS TABLE OF wycieczki_r;

CREATE OR REPLACE
FUNCTION dostepne_wycieczki(kraj    WYCIECZKI.KRAJ%TYPE, data_od DATE,
                            data_do DATE)
  return wycieczki_t as v_ret wycieczki_t;
  istnieje                    integer;
  BEGIN
    IF data_do < data_od
    THEN
      raise_application_error(-20003, 'Nieprawidłowy przedział dat');
    END IF;

    SELECT wycieczki_r(w.ID_WYCIECZKI, w.NAZWA, w.KRAJ, w.DATA, w.OPIS,
                       w.LICZBA_MIEJSC)
        BULK COLLECT INTO v_ret
    FROM WYCIECZKI w
    WHERE w.KRAJ = dostepne_wycieczki.kraj
      AND w.DATA >= data_od
      AND w.DATA <= data_do
      AND w.LICZBA_MIEJSC > (SELECT COUNT(*)
                             FROM REZERWACJE r
                             WHERE r.status <> 'A'
                               AND r.ID_WYCIECZKI = w.ID_WYCIECZKI);
    return v_ret;
  end dostepne_wycieczki;

-- przykład
SELECT *
FROM dostepne_wycieczki('Polska', TO_DATE('2016-01-01', 'YYYY-MM-DD'), TO_DATE('2020-01-01', 'YYYY-MM-DD'));


