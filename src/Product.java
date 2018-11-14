import javax.persistence.*;


@Table(name = "Products")
@Entity
public class Product {
    @Id
    public String ProductName;
    public int UnitsOnStock;

    @ManyToOne
    private Supplier SuppliedBy;

    public Product() {
        // for Hibernate
    }

    public Product(String name) {
        ProductName = name;
        UnitsOnStock = 0;
    }

    public Supplier getSuppliedBy() {
        return SuppliedBy;
    }

    public void setSuppliedBy(Supplier suppliedBy) {
        SuppliedBy = suppliedBy;
    }
}
