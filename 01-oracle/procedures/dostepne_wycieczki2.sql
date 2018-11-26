CREATE OR REPLACE
FUNCTION dostepne_wycieczki2(kraj    WYCIECZKI.KRAJ%TYPE, data_od DATE,
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
    WHERE w.KRAJ = dostepne_wycieczki2.kraj
      AND w.DATA >= data_od
      AND w.DATA <= data_do
      AND w.LICZBA_WOLNYCH_MIEJSC > 0;
    return v_ret;
  end dostepne_wycieczki2;

