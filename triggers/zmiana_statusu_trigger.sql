CREATE OR REPLACE TRIGGER zmiana_statusu_trigger
  AFTER UPDATE
  ON REZERWACJE
  FOR EACH ROW
  DECLARE
    wolne_miejsca_delta int;
  BEGIN
    INSERT INTO REZERWACJE_LOG (ID_REZERWACJI, DATA, STATUS)
    VALUES (:NEW.NR_REZERWACJI, CURRENT_DATE, :NEW.STATUS);


    CASE
      WHEN :OLD.STATUS = 'A' AND :NEW.STATUS <> 'A'
      THEN
        wolne_miejsca_delta := -1;

      WHEN :OLD.STATUS <> 'A' AND :NEW.STATUS = 'A'
      THEN
        wolne_miejsca_delta := 1;
    ELSE
      wolne_miejsca_delta := 0;
    END CASE;

    UPDATE WYCIECZKI w
    SET LICZBA_WOLNYCH_MIEJSC = LICZBA_WOLNYCH_MIEJSC + wolne_miejsca_delta
    WHERE w.ID_WYCIECZKI = :NEW.ID_WYCIECZKI;
  end zmiana_statusu_trigger;
