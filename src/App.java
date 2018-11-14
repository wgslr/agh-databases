import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.cfg.Configuration;

import java.util.Scanner;


public class App {
    public static SessionFactory sessionFactory;

    public static void main(String argv[]) {
        SessionFactory sf = getSessionFactory();
        Scanner inputScanner = new Scanner(System.in);

//        Session session = sf.openSession();
//        Transaction transaction = session.beginTransaction();
//
        System.out.println("Provide product name:");
        String prodName = inputScanner.nextLine();
//        System.out.println("Provide product stock value:");
//        Product p = new Product(prodName);
//        p.UnitsOnStock = inputScanner.nextInt();
//        session.save(p);
//
//        transaction.commit();
//        session.close();

        Session session = sf.openSession();
        Transaction transaction = session.beginTransaction();

        System.out.println("Provide company name");
        String company = inputScanner.nextLine();
        System.out.println("Provide company city");
        String city = inputScanner.nextLine();
        System.out.println("Provide company street");
        String street = inputScanner.nextLine();

        Product gotP = session.get(Product.class, prodName);
        Supplier s = new Supplier(company, street, city);

        gotP.setSuppliedBy(s);
        session.save(s);
//        session.save(p);

        transaction.commit();
        session.close();
    }

    private static SessionFactory getSessionFactory() {
        if (sessionFactory == null) {
            Configuration cfg = new Configuration();
            sessionFactory = cfg.configure().buildSessionFactory();
        }
        return sessionFactory;
    }
}
