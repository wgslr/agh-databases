import javax.persistence.Embeddable;

@Embeddable
public class Address {
    public String Street;
    public String City;
    public String Country;

    public Address() {
    }

    public Address(String street, String city, String country) {
        Street = street;
        City = city;
        Country = country;
    }
}
