import pymongo
# from py2neo import Graph, Node, Relationship
from neo4j import GraphDatabase


srv_url = ""
mongo_database = ""
mongo_collection = ""
neo_link = ""
neo_user = ""
neo_pass = ""

client = pymongo.MongoClient(srv_url)
# db = client.user_login_system
pothole_db = client[mongo_database]
mycol = pothole_db[mongo_collection]

x = mycol.find()

# graph = Graph("localhost:7474","pass")


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


conn.query("MATCH ()-[r]->() DELETE r")
conn.query("MATCH (n) DELETE n")

for m in x:
    id =  m["_id"]
    type = m["type"]
    geom_type = m["geometry"]["type"]
    x_coord = m["geometry"]["coordinates"][0]
    y_coord =  m["geometry"]["coordinates"][1]
    road = m['properties']['road']
    city = m['properties']['city']
    locality = m['properties']['locality']
    postal_code = m['properties']['postal_code']
    priority = m["priority"]

    # conn.query("MERGE(p : Pothole{type : '" + str(type) + "' , geom_type : '" + str(geom_type) + "' , x_coord : " + str(x_coord) +", y_coord : " + str(y_coord) + "})")
    conn.query("MERGE(p : Pothole{type : '" + str(type) + "' , geom_type : '" + str(geom_type) + "' , location : Point({latitude:" + str(x_coord) + ",longitude:" + str(y_coord) + "}), priority:" + str(priority) + "})")
    conn.query("MERGE(s : Road {road_name : '" + str(road) + "' , locality : '" + str(locality) + "' , postal_code : '" + str(postal_code) +"'})")
    conn.query("MERGE(c : City { city_name : '" + str(city) + "'})")

    conn.query("MATCH (p:Pothole), (s:Road) WHERE " +
              "p.type = '" + str(type) + "' AND p.geom_type = '" + str(geom_type) + "' AND p.location  = Point({latitude:" + str(x_coord) + ",longitude:" + str(y_coord) + "})" +
               " AND s.road_name = '" + str(road) + "' AND s.locality = '" + str(locality) + "' AND  s.postal_code = '" + str(postal_code) +"'" +
               " MERGE (p)-[r:is_on_road]->(s)")


    conn.query( "MATCH (s:Road) , (c:City) WHERE " +
                "s.road_name = '" + str(road) + "' AND s.locality = '" + str(locality) + "' AND s.postal_code = '" + str(postal_code) +"'" +
                " AND c.city_name = '" + str(city) + "'" +
                "MERGE (s)-[r:is_in_city]->(c)")
    # MERGE(p: Pothole{name: "Marina"})

    # graph.run("CREATE(a : Pothole{test : 'test' })")



    print(id)
    print(m)
print(x)

