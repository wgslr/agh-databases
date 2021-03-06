import javax.persistence.*;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;
import java.util.stream.Collectors;


@Table(name = "Products")
@Entity
public class Product {
    @Id
    public String ProductName;
    public int UnitsOnStock;

    @ManyToOne
    @JoinColumn(name = "SUPPLIED_BY", nullable = false)
    private Supplier suppliedBy;


    @ManyToMany(mappedBy = "includesProducts", fetch = FetchType.EAGER,
            cascade = CascadeType.PERSIST)
    private Set<Invoice> canBeSoldIn = new HashSet<>();

    @ManyToMany(mappedBy = "products",
            cascade = CascadeType.PERSIST)
    private Set<Order> orders = new HashSet<>();

    @ManyToOne
    private Category category;

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

    public Set<Invoice> getCanBeSoldIn() {
        return canBeSoldIn;
    }

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
        if (!category.getProducts().contains(this)) {
            category.addProduct(this);
        }
    }

    public Set<Order> getOrders() {
        return Collections.unmodifiableSet(orders);
    }

}
