import javax.persistence.*;
import java.util.HashSet;
import java.util.Set;

@Entity
public class Invoice {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int InvoiceNumber;
    private int Quantity;

    @ManyToMany
    private Set<Product> includesProducts = new HashSet<>();

    public Invoice() {
    }

    public Invoice(int invoiceNumber, int quantity) {
        InvoiceNumber = invoiceNumber;
        Quantity = quantity;
    }

    public void addProduct(Product p, int quantity) {
        includesProducts.add(p);
        this.Quantity += quantity;
    }

    public int getInvoiceNumber() {
        return InvoiceNumber;
    }

    public int getQuantity() {
        return Quantity;
    }

    public void setQuantity(int quantity) {
        Quantity = quantity;
    }

    public Set<Product> getProducts(){
        return includesProducts;
    }
}
