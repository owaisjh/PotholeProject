#
# import pymongo
# import geopy.distance
# client = pymongo.MongoClient("mongodb+srv://admin:Password@data.q5k3c.mongodb.net/Data?retryWrites=true&w=majority")
# db = client.pothole_data
#
#
# radian=637.1393
#
# lon= 72.8501607
# lat= 19.1299066
# #
# # #landmark = db.landmarks.findOne({name: "Washington DC"});
# # # res= db.potholes.find(
# # #    {
# # #
# # #         "$nearSphere": {
# # #            "$geometry": {
# # #               "type" : "Point",
# # #               "coordinates" : [ lat, lon ]
# # #            },
# # #            "$minDistance": 1000,
# # #            "$maxDistance": 5000
# # #         }
# # #      }
# # #
# # # )
# # res = db.potholes.find(
# #    { "geometry" : { "$nearSphere" : [ -73.9667, 40.78 ], "$maxDistance": 0.10 } }
# # )
# # for i in res:
# #     print(i)
# # # response = pothole_db.potholes.find({"reporter_address": values["account-address"], "isFixed": False})
# # #db.landmarks.find(query).pretty();
# #
# # # a = {
# # #     "_id": uuid.uuid4().hex,
# # #     "type": "Feature",
# # #     "geometry": {
# # #         "type": "Point",
# # #         "coordinates": [float(values["lat"]), float(values["long"])]
# # #     },
# # #     "properties": {
# # #         "road": values["road"],
# # #         "city": values["city"],
# # #         "locality": values["locality"],
# # #         "postal_code": values["postcode"]
# # #     },
# # #     'reporter_address': values["account-address"],
# # #     'path': values["hash"],
# # #     'isFixed': False,
# # #     'fixed_path': None,
# # #     'transaction_hash': None
# # # }
#
# # coor0=(lat, lon)
# # response = db.potholes.find({ "isFixed": False })
# # arr = []
# # for i in response:
# #     latd= i['geometry']['coordinates'][0]
# #     lond= i['geometry']['coordinates'][1]
# #     coor1= (latd,lond)
# #     print(coor0)
# #     print(coor1)
# #
# #     print(geopy.distance.geodesic(coor0, coor1).m)
#
#
# from geopy.geocoders import Nominatim
# geolocator = Nominatim(user_agent="pothole")
# arr=[(19.1299011, 72.8501674)]
#
# for i in arr:
#
#     val= str(i[0]) + "," + str(i[1])
#     location = geolocator.reverse(val)
#     Location=str(location)
#     Location=Location.split(",")
#     print(Location)
import ipfsApi

api = ipfsApi.Client('https://ipfs.infura.io', 5001)
res = api.add("user/new-cert.jpg")
print(res[0]["Hash"])
