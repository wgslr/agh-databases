import javax.persistence.*;


@Table(name = "Products")
@Entity
public class Product {
    @Id
    public String ProductName;
    public int UnitsOnStock;

    @ManyToOne
    @JoinColumn(name = "SUPPLIED_BY")
    private Supplier suppliedBy;

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

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
        if(!category.getProducts().contains(this)){
            category.addProduct(this);
        }
    }
}
