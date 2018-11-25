import com.sun.scenario.effect.impl.prism.PrDrawable;

import javax.persistence.*;
import java.util.HashSet;
import java.util.Set;

@Entity
@SecondaryTable(name = "Address")
public class Supplier {
    @Id
    String CompanyName;

    @Column(table = "Address")
    String Street;
    @Column(table = "Address")
    String City;

    @OneToMany
    @JoinColumn(name="SUPPLIED_BY")
    private Set<Product> supplies = new HashSet<>();

    public Supplier() {
    }

    public Supplier(String companyName, String street, String city) {
        CompanyName = companyName;
        Street = street;
        City = city;
    }

    public void addSuppliedProduct(Product p){
        supplies.add(p);
        p.setSuppliedBy(this);
    }

    public boolean suppliesProduct(Product p){
        return supplies.contains(p);
    }
}
