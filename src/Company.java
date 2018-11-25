import javax.persistence.*;

@Entity
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
public class Company {
    @Id
    String CompanyName;

    String Street;
    String City;

    public Company() {
    }

    public Company(String companyName, String street, String city) {
        CompanyName = companyName;
        Street = street;
        City = city;
    }
}
