import com.sun.scenario.effect.impl.prism.PrDrawable;

import javax.persistence.*;
import java.util.HashSet;
import java.util.Set;

@Entity
public class Supplier extends Company {

    public String bankAccountNumber;


    @OneToMany
    @JoinColumn(name = "SUPPLIED_BY")
    private Set<Product> supplies = new HashSet<>();


    public Supplier() {
        super();
    }

    public Supplier(String companyName, String street, String city, String account) {
        super(companyName, street, city);
        bankAccountNumber = account;
    }

    public void addSuppliedProduct(Product p) {
        supplies.add(p);
        p.setSuppliedBy(this);
    }

    public boolean suppliesProduct(Product p) {
        return supplies.contains(p);
    }
}
