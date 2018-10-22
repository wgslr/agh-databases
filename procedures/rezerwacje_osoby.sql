CREATE OR REPLACE
FUNCTION rezerwacje_osoby(id_osoby OSOBY.ID_OSOBY%TYPE)
  return osoby_wycieczki_t as v_ret osoby_wycieczki_t;
  istnieje                          integer;
  BEGIN
    SELECT COUNT(*) INTO istnieje FROM OSOBY WHERE OSOBY.ID_OSOBY = rezerwacje_osoby.id_osoby;

    IF istnieje = 0 THEN
      raise_application_error(-20002, 'Brak osoby o podanym id');
    END IF;

    SELECT osoby_wycieczki_r(w.KRAJ, w.DATA, w.NAZWA, o.IMIE,
                             o.NAZWISKO, r.STATUS)
        BULK COLLECT INTO v_ret
    FROM WYCIECZKI w
           JOIN REZERWACJE r ON w.ID_WYCIECZKI = r.ID_WYCIECZKI
           JOIN OSOBY o ON r.ID_OSOBY = o.ID_OSOBY
    WHERE o.ID_OSOBY = rezerwacje_osoby.id_osoby;
    return v_ret;
  end rezerwacje_osoby;

SELECT * FROM rezerwacje_osoby(2);
