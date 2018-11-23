import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.cfg.Configuration;

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

        for (Object inv : invoices) {
            Invoice invoice = (Invoice) inv;
            System.out.println(String.format("Products on invoice no %d:",
                    invoice.getInvoiceNumber()));
            for (Product p : invoice.getProducts()) {
                System.out.println(String.format("  %s", p.ProductName));
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
