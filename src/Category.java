import org.hibernate.collection.internal.PersistentList;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

@Entity
public class Category {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int CategoryID;
    private String Name;

    @OneToMany
    private List<Product> products = new ArrayList<>();

    public Category() {
    }

    public Category(String name) {
        this.Name = name;
    }

    public int getCategoryID() {
        return CategoryID;
    }

    public String getName() {
        return Name;
    }

    public void setName(String name) {
        Name = name;
    }

    public List<Product> getProducts() {
        return Collections.unmodifiableList(products);
    }

    public void addProduct(Product p) {
        products.add(p);
        p.setCategory(this);
    }

    public void removeProduct(Product p) {
        products.remove(p);
    }
}
