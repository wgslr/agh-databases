import javax.persistence.*;
import java.util.HashSet;
import java.util.Set;


@Table(name = "Products")
@Entity
public class Product {
    @Id
    public String ProductName;
    public int UnitsOnStock;

    @ManyToOne
    @JoinColumn(name = "SUPPLIED_BY")
    private Supplier suppliedBy;

    @ManyToMany(mappedBy = "includesProducts")
    private Set<Invoice> canBeSoldIn = new HashSet<>();

    public Product() {
        // for Hibernate
    }

    public Product(String name) {
        ProductName = name;
        UnitsOnStock = 0;
    }

    public Supplier getSuppliedBy() {
        return suppliedBy;
    }

    public void setSuppliedBy(Supplier suppliedBy) {
        this.suppliedBy = suppliedBy;
        if (!suppliedBy.suppliesProduct(this)) {
            suppliedBy.addSuppliedProduct(this);
        }
    }
}
