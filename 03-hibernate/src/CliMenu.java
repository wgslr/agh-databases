import java.util.HashMap;
import java.util.Map;
import java.util.Scanner;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.function.Consumer;

public class CliMenu {
    private class Option {
        public final String text;
        public final Consumer<Scanner> action;

        private Option(String text, Consumer<Scanner> action) {
            this.text = text;
            this.action = action;
        }
    }

    private Map<Integer, Option> options = new HashMap<>();
    private AtomicInteger maxIndex = new AtomicInteger(0);
    private String header;

    private String rendered;

    private boolean oneshot = true;

    public CliMenu(String header) {
        this.header = header;
    }

    public boolean isOneshot() {
        return oneshot;
    }

    public void setOneshot(boolean oneshot) {
        this.oneshot = oneshot;
    }

    public void setHeader(String text) {
        header = text;
        rendered = null;
    }

    public void addOption(String text, Consumer<Scanner> handler) {
        int index = maxIndex.incrementAndGet();
        options.put(index, new Option(text, handler));
        rendered = null;
    }

    public void display() {
        Scanner inputScanner = new Scanner(System.in);
        do {
            System.out.println(getText());

            Integer choice = null;
            do {
                choice = inputScanner.nextInt();
            } while (!options.containsKey(choice));

            options.get(choice).action.accept(inputScanner);

            System.out.println();
        } while (!oneshot);
    }

    private String getText() {
        if (rendered == null) {
            rendered = header + "\n";
            options.forEach((idx, opt) -> rendered += String.format("%02d %s\n", idx, opt.text));
        }
        return rendered;

    }

}
