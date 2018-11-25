import com.sun.scenario.effect.impl.prism.PrDrawable;

import javax.persistence.*;
import java.util.HashSet;
import java.util.Set;

@Entity
public class Supplier {
    @Id
    String CompanyName;

    @Embedded
    private Address Address;

    @OneToMany
    @JoinColumn(name = "SUPPLIED_BY")
    private Set<Product> supplies = new HashSet<>();

    public Supplier() {
    }

    public Supplier(String companyName, String street, String city, String country) {
        CompanyName = companyName;
        this.Address = new Address(street, city, country);
    }

    public void addSuppliedProduct(Product p) {
        supplies.add(p);
        p.setSuppliedBy(this);
    }

    public boolean suppliesProduct(Product p) {
        return supplies.contains(p);
    }

    public Address getAddress() {
        return Address;
    }

    public void setAddress(Address address) {
        Address = address;
    }
}
