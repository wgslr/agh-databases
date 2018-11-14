import javax.persistence.Entity;
import javax.persistence.Id;

@Entity
public class Supplier {
    @Id
    String CompanyName;
    String Street;
    String City;

    public Supplier() {
    }

    public Supplier(String companyName, String street, String city) {
        CompanyName = companyName;
        Street = street;
        City = city;
    }
}
