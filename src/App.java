import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.cfg.Configuration;

import java.util.Scanner;


public class App {
    public static SessionFactory sessionFactory;

    public static void main(String argv[]) {

        SessionFactory sf = getSessionFactory();
        Session session = sf.openSession();
        Transaction transaction = session.beginTransaction();

        Scanner inputScanner = new Scanner(System.in);
        String prodName = inputScanner.nextLine();
        int stock = inputScanner.nextInt();

        Product p = new Product(prodName);
        p.UnitsOnStock = stock;
        session.save(p);

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
