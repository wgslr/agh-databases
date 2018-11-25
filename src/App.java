import org.omg.PortableInterceptor.SUCCESSFUL;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.EntityTransaction;
import javax.persistence.Persistence;
import java.util.List;
import java.util.Scanner;


public class App {
    private static EntityManagerFactory entityManagerFactory;
    private static EntityManager entityManager;


    public static void main(String argv[]) {
        entityManager = getEntityManager();

        try {
            CliMenu mainMenu = new CliMenu("Choose action");
            mainMenu.setOneshot(false);
            mainMenu.addOption("Add product", App::addProduct);
            mainMenu.addOption("List products", App::listProducts);
            mainMenu.addOption("Add supplier", App::addSupplier);
            mainMenu.addOption("List suppliers", App::listSuppliers);
            mainMenu.addOption("Add customer", App::addCustomer);
            mainMenu.addOption("List customers", App::listCustomers);
            mainMenu.addOption("Exit", x -> {
                cleanup();
                System.exit(0);
            });

            mainMenu.display();


        } finally {
            cleanup();
        }
    }

    private static EntityManager getEntityManager() {
        if (entityManagerFactory == null) {
            entityManagerFactory = Persistence.createEntityManagerFactory("derby");
        }
        return entityManagerFactory.createEntityManager();
    }

    private static void cleanup() {
        entityManager.close();
        entityManagerFactory.close();
    }

    private static void addProduct(Scanner scanner) {
        EntityTransaction transaction = entityManager.getTransaction();
        transaction.begin();

        System.out.println("Name: ");
        String name = readNonemptyLine(scanner);

        System.out.println("Stock: ");
        int initialStock = scanner.nextInt();

        Product product = new Product(name);
        product.UnitsOnStock = initialStock;

        List<Supplier> suppliers = getAll(Supplier.class);
        CliMenu supplierMenu = new CliMenu("Choose product's supplier");
        suppliers.forEach(s ->
                supplierMenu.addOption(s.CompanyName, x -> product.setSuppliedBy(s))
        );
        supplierMenu.display();

        entityManager.persist(product);
        transaction.commit();
    }

    private static void listProducts(Scanner scanner) {
        List<Product> products = getAll(Product.class);

        System.out.println("Stock | Name\t\t| Supplier");
        products.forEach(
                p -> System.out.println(String.format("%5d | %s | %s", p.UnitsOnStock,
                        p.ProductName, p.getSuppliedBy().CompanyName)));
    }

    private static void addSupplier(Scanner scanner) {
        String name, street, city, bankAccount;

        System.out.println("Company name: ");
        name = readNonemptyLine(scanner);

        System.out.println("Street: ");
        street = readNonemptyLine(scanner);

        System.out.println("City: ");
        city = readNonemptyLine(scanner);

        System.out.println("Bank account: ");
        bankAccount = readNonemptyLine(scanner);

        Supplier s = new Supplier(name, street, city, bankAccount);
        EntityTransaction transaction = entityManager.getTransaction();
        transaction.begin();
        entityManager.persist(s);
        transaction.commit();
    }

    private static void listSuppliers(Scanner scanner) {
        List<Supplier> suppliers = getAll(Supplier.class);

        System.out.println("Name");
        suppliers.stream().map(s -> s.CompanyName).forEach(System.out::println);
    }

    private static void addCustomer(Scanner scanner) {
        String name, street, city;
        double discount;

        System.out.println("Company name: ");
        name = readNonemptyLine(scanner);

        System.out.println("Street: ");
        street = readNonemptyLine(scanner);

        System.out.println("City: ");
        city = readNonemptyLine(scanner);

        System.out.println("Bank account: ");
        discount = scanner.nextDouble();

        Customer c = new Customer(name, street, city, discount);
        EntityTransaction transaction = entityManager.getTransaction();
        transaction.begin();
        entityManager.persist(c);
        transaction.commit();
    }

    private static void listCustomers(Scanner scanner) {
        List<Customer> customers = getAll(Customer.class);

        System.out.println("Name");
        customers.stream().map(c -> c.CompanyName).forEach(System.out::println);
    }

    private static <T> List<T> getAll(Class<T> entity) {
        return entityManager.createQuery("SELECT t FROM " + entity.getName() + " t", entity)
                .getResultList();
    }

    private static String readNonemptyLine(Scanner scanner) {
        String line;
        do {
            line = scanner.nextLine();
        } while (line == null || line.chars().allMatch(Character::isWhitespace));
        return line;
    }
}
