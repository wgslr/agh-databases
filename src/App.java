import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.cfg.Configuration;


public class App {
    public static SessionFactory sessionFactory;

    public static void main(String argv[]) {

        SessionFactory sf = getSessionFactory();
        Session session = sf.openSession();
        Transaction transaction = session.beginTransaction();
        transaction.commit();
        session.close();
    }

    private static SessionFactory getSessionFactory(){
        if(sessionFactory == null){
            Configuration cfg = new Configuration();
            sessionFactory = cfg.configure().buildSessionFactory();
        }
        return sessionFactory;
    }
}
