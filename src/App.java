import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.cfg.Configuration;
import org.omg.PortableInterceptor.INACTIVE;

import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;


public class App {
    public static SessionFactory sessionFactory;

    public static void main(String argv[]) {
        SessionFactory sf = getSessionFactory();

        Session session = sf.openSession();
        Transaction transaction = session.beginTransaction();

        Supplier s = new Supplier("Komputronik", "Kamienskiego", "Krakow");
        List<Product> products = Stream.of("Komputer", "Myszka", "CPU")
                .map(Product::new)
                .peek(p -> p.UnitsOnStock = 100)
                .peek(session::save)
                .collect(Collectors.toList());

        for (Product product : products) {
            System.out.println(product);
            System.out.println(product.ProductName + " " + product.UnitsOnStock);
            s.addSuppliedProduct(product);
        }
        session.save(s);

        Invoice inv1 = new Invoice();
        Invoice inv2 = new Invoice();

        inv1.addProduct(products.get(0), 5);
        inv1.addProduct(products.get(1), 6);

        inv2.addProduct(products.get(2), 2);

        session.save(inv1);
        session.save(inv2);

        transaction.commit();

        transaction = session.beginTransaction();

        List<Invoice> invoices = session.createQuery("from Invoice").list();

        for (Invoice inv : invoices) {
            System.out.println(String.format("Products on invoice no %d:",
                    inv.getInvoiceNumber()));
            for (Product p : inv.getProducts()) {
                System.out.println(String.format("  %s", p.ProductName));
            }
        }

        List<Product> gotProducts = session.createQuery("FROM Product p JOIN FETCH p.canBeSoldIn").list();


        for (Product prod : gotProducts) {
            System.out.println(String.format("Product '%s' is on invoices:",
                    prod.ProductName));

            invoices =
                    session.createQuery("SELECT i from Product p  JOIN p.canBeSoldIn i WHERE  p" +
                            ".ProductName = :name").setParameter("name", prod.ProductName).list();
            for (Invoice i : invoices) {
                System.out.println(i.getInvoiceNumber());
            }
        }


        transaction.commit();

        session.close();
        sf.close();
    }

    private static SessionFactory getSessionFactory() {
        if (sessionFactory == null) {
            Configuration cfg = new Configuration();
            sessionFactory = cfg.configure().buildSessionFactory();
        }
        return sessionFactory;
    }
}
