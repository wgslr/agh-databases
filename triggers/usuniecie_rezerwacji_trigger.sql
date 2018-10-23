CREATE OR REPLACE TRIGGER usuniecie_rezerwacji_trigger
  BEFORE DELETE ON REZERWACJE
  FOR EACH ROW
  BEGIN
    raise_application_error(-20200, 'Usuwanie rezerwacji zabronione');
  end;
