package pl.edu.agh.ki.bd2;

public class Solution {

    private final GraphDatabase graphDatabase = GraphDatabase.createDatabase();

    public void databaseStatistics() {
        System.out.println(graphDatabase.runCypher("CALL db.labels()"));
        System.out.println(graphDatabase.runCypher("CALL db.relationshipTypes()"));
    }

    public void runAllTests() {
        System.out.println(findActorByName("Emma Watson"));
        System.out.println(findMovieByTitleLike("Star Wars"));
        System.out.println(findRatedMoviesForUser("maheshksp"));
        System.out.println(findCommonMoviesForActors("Emma Watson", "Daniel Radcliffe"));
        System.out.println(findMovieRecommendationForUser("emileifrem"));
    }

    private String findActorByName(final String actorName) {
        return graphDatabase.runCypher(
                String.format("MATCH (p:Person {name: \"%s\"}) return p", actorName)
        );
    }

    private String findMovieByTitleLike(final String movieName) {
        String query = "MATCH (m:Movie) WHERE m.title CONTAINS \"%s\" RETURN m.title LIMIT 1";
        return graphDatabase.runCypher(String.format(query, movieName));
    }

    private String findRatedMoviesForUser(final String userLogin) {
        String query = "MATCH (u:User {login: \"%s\"}) -[:RATED]-> (m:Movie) RETURN m.title";
        return graphDatabase.runCypher(String.format(query, userLogin));
    }

    private String findCommonMoviesForActors(String actorOne, String actrorTwo) {
        String query = "MATCH (a1:Actor {name: \"%s\"}) -[:ACTS_IN]-> (m:Movie) <-[:ACTS_IN]-" +
                "(a2:Actor {name: \"%s\"}) RETURN m.title";
        return graphDatabase.runCypher(String.format(query, actorOne, actrorTwo));
    }

    /**
     * Finds movies rated highly be people who has given the same rating
     * to some movie as the given user.
     */
    private String findMovieRecommendationForUser(final String userLogin) {
        String query = "MATCH (u:User {login: \"%s\"}) " +
                "-[r1:RATED]-> (m:Movie) " +
                "<-[r2:RATED]- (other:User) " +
                "-[r3:RATED]-> (m2:Movie) " +
                "WHERE r1.stars = r2.stars AND r3.stars >= 3 RETURN m2.title";
        return graphDatabase.runCypher(String.format(query, userLogin));
    }

}
