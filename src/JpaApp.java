import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.cfg.Configuration;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.EntityTransaction;
import javax.persistence.Persistence;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;


public class JpaApp {
    public static EntityManagerFactory entityManagerFactory;

    public static void main(String argv[]) {
        EntityManager em = getEntityManager();

        EntityTransaction transaction = em.getTransaction();
        transaction.begin();

        Supplier s = new Supplier("Komputronik", "Kamienskiego", "Krakow");
        List<Product> products = Stream.of("Komputer", "Myszka", "CPU", "Pan Tadeusz",
                "Harry Potter")
                .map(Product::new)
                .peek(p -> p.UnitsOnStock = 100)
                .peek(em::persist)
                .collect(Collectors.toList());

        List<Category> categories = Stream.of("Elektronika", "Ksiazki")
                .map(Category::new)
                .collect(Collectors.toList());

        for (Product product : products) {
            System.out.println(product);
            System.out.println(product.ProductName + " " + product.UnitsOnStock);
            s.addSuppliedProduct(product);
        }

        products.subList(0, 3).forEach(p -> categories.get(0).addProduct(p));
        products.subList(3, 5).forEach(p -> categories.get(1).addProduct(p));
        categories.forEach(em::persist);

        em.persist(s);

        Invoice inv1 = new Invoice();
        Invoice inv2 = new Invoice();

        inv1.addProduct(products.get(0), 5);
        inv1.addProduct(products.get(1), 6);

        inv2.addProduct(products.get(2), 2);

        em.persist(inv1);
        em.persist(inv2);

        transaction.commit();

        transaction = em.getTransaction();
        transaction.begin();

        List<Invoice> invoices = em.createQuery("from Invoice").getResultList();

        for (Invoice inv : invoices) {
            System.out.println(String.format("Products on invoice no %d:",
                    inv.getInvoiceNumber()));
            for (Product p : inv.getProducts()) {
                System.out.println(String.format("  %s", p.ProductName));
            }
        }

        List<Product> gotProducts =
                em.createQuery("FROM Product p JOIN FETCH p.canBeSoldIn").getResultList();


        for (Product prod : gotProducts) {
            System.out.println(String.format("Product '%s' is on invoices:", prod.ProductName));

            invoices = em.createQuery("SELECT i from Product p  JOIN p.canBeSoldIn i WHERE  p" +
                            ".ProductName = :name").setParameter("name", prod.ProductName).getResultList();
            for (Invoice i : invoices) {
                System.out.println(i.getInvoiceNumber());
            }
        }



        System.out.println("Categories:");
        for (Category cat : em.createQuery("from Category", Category.class).getResultList()) {
            System.out.println(String.format("  %2d %s", cat.getCategoryID(), cat.getName()));
            for (Product p : cat.getProducts()) {
                System.out.println(String.format("    %s", p.ProductName));
            }
        }


        System.out.println("Products:");
        for (Product p :
                (List<Product>) em.createQuery("SELECT p from Product p LEFT JOIN FETCH p" +
                        ".category").getResultList()) {

            if (p.getCategory() != null) {
                System.out.println(String.format("Product %s is in category %s", p.ProductName,
                        p.getCategory().getName()));
            } else {
                System.out.println(
                        String.format("Product %s has no category assigned", p.ProductName));
            }
        }

        transaction.commit();

        em.close();
    }

    private static EntityManager getEntityManager() {
        if (entityManagerFactory == null) {
            entityManagerFactory = Persistence.createEntityManagerFactory("derby");
        }
        return entityManagerFactory.createEntityManager();
    }
}
