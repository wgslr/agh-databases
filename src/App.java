import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.cache.spi.entry.CacheEntry;
import org.hibernate.cfg.Configuration;

import java.awt.*;
import java.util.List;
import java.util.Scanner;
import java.util.stream.Collectors;
import java.util.stream.Stream;


public class App {
    public static SessionFactory sessionFactory;

    public static void main(String argv[]) {
        SessionFactory sf = getSessionFactory();

        Session session = sf.openSession();
        Transaction transaction = session.beginTransaction();

        Supplier s = new Supplier("Komputronik", "Kamienskiego", "Krakow");
        List<Product> products = Stream.of("Komputer", "Myszka", "CPU", "Pan Tadeusz",
                "Harry Potter")
                .map(Product::new)
                .peek(session::save)
                .collect(Collectors.toList());

        List<Category> categories = Stream.of("Elektronika", "Ksiazki")
                .map(Category::new)
                .collect(Collectors.toList());

        for (Product product : products) {
            System.out.println(product);
            System.out.println(product.ProductName);
            s.addSuppliedProduct(product);
        }

        products.subList(0, 3).forEach(p -> categories.get(0).addProduct(p));
        products.subList(3, 5).forEach(p -> categories.get(1).addProduct(p));
        categories.forEach(session::save);

        session.save(s);

        transaction.commit();
        transaction = session.beginTransaction();

        System.out.println("Categories:");
        for (Category cat : session.createQuery("from Category", Category.class).list()) {
            System.out.println(String.format("  %2d %s", cat.getCategoryID(), cat.getName()));
            for (Product p : cat.getProducts()) {
                System.out.println(String.format("    %s", p.ProductName));
            }
        }


        System.out.println("Products:");
        for (Product p :
                (List<Product>) session.createQuery("SELECT p from Product p LEFT JOIN FETCH p" +
                        ".category").list()) {

            if (p.getCategory() != null) {
                System.out.println(String.format("Product %s is in category %s", p.ProductName,
                        p.getCategory().getName()));
            } else {
                System.out.println(
                        String.format("Product %s has no category assigned", p.ProductName));
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
