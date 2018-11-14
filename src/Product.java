import javax.persistence.*;


@Table(name = "Products")
@Entity
public class Product {
    @Id
    String ProductName;
    int UnitsOnStock;

    public Product() {
        // for Hibernate
    }

    public Product(String name) {
        ProductName = name;
        UnitsOnStock = 0;
    }
}
