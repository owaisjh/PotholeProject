from neo4j import GraphDatabase

neo_link = ""
neo_user = ""
neo_pass = ""

class Neo4jConnection:

    def __init__(self, uri, user, pwd):
        self.__uri = uri
        self.__user = user
        self.__pwd = pwd
        self.__driver = None
        try:
            self.__driver = GraphDatabase.driver(self.__uri, auth=(self.__user, self.__pwd))
        except Exception as e:
            print("Failed to create the driver:", e)

    def close(self):
        if self.__driver is not None:
            self.__driver.close()

    def query(self, query, db=None):
        assert self.__driver is not None, "Driver not initialized!"
        session = None
        response = None
        try:
            session = self.__driver.session(database=db) if db is not None else self.__driver.session()
            response = list(session.run(query))
        except Exception as e:
            print("Query failed:", e)
        finally:
            if session is not None:
                session.close()
        return response

# conn = Neo4jConnection(uri="bolt://localhost:7687", user="neo4j", pwd="pass")
conn = Neo4jConnection(uri=neo_link, user=neo_user, pwd=neo_pass)


# results = conn.query("MATCH (n)-[:is_on_road]->()-[:is_in_city]->(c) RETURN COUNT(n),collect(distinct c.NAME), c.city_name ORDER BY count(n) DESC")
# print(f"{results[0][2]} has highest number of potholes")

# results = conn.query("MATCH (n)-[:is_on_road]->()-[:is_in_city]->(c) RETURN SUM(n.priority),collect(distinct c.NAME), c.city_name ORDER BY SUM(n.priority) DESC")
# print(f"{results[0][2]} has highest priority with {results[0][0]} complaints")