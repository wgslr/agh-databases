import javax.annotation.Generated;
import javax.persistence.*;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;
import java.util.stream.Collectors;

@Entity
@Table(name = "\"ORDER\"")
public class Order {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int OrderID;

    @ManyToOne(optional = false)
    private Customer customer;

    @ManyToMany
    private Set<Product> products = new HashSet<>();

    public Order() {
    }

    public int getOrderID() {
        return OrderID;
    }

    public Customer getCustomer() {
        return customer;
    }

    public void setCustomer(Customer customer) {
        this.customer = customer;
    }

    public Set<Product> getProducts() {
        return Collections.unmodifiableSet(products);
    }

    public void addProduct(Product product) {
        this.products.add(product);
    }
}
