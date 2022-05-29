from flask import Flask, render_template, request, session, redirect
import json
import coremltools as ct
import os
import pymongo
from flask_cors import CORS
import PIL.Image
import numpy as np
from bson import json_util
from functools import wraps
import ipfsApi
import uuid
import statistics
from sklearn import metrics
import seaborn as sns
from sklearn.cluster import DBSCAN
import geopy.distance


client = pymongo.MongoClient("mongo url")
db = client.user_login_system
pothole_db = client.pothole_data

mlmodel = ct.models.MLModel('PotholeCNN2.mlmodel')


def load_image(path, resize_to=None):
    img = PIL.Image.open(path)
    if resize_to is not None:
        img = img.resize(resize_to, PIL.Image.ANTIALIAS)
    img_np = np.array(img).astype(np.float32)
    return img_np, img


app = Flask(__name__)
CORS(app)
app.secret_key = "asjnddjenfhtiorjiongoi58u3895pq5p327"


# Decorators
def login_required_official(f):
    @wraps(f)
    def wrap(*args, **kwargs):
        if 'logged_in_official' in session:
            return f(*args, **kwargs)
        else:
            return "Not Logged In as Official", 401

    return wrap


def login_required_user(f):
    @wraps(f)
    def wrap(*args, **kwargs):
        if 'logged_in_user' in session:
            return f(*args, **kwargs)
        else:
            return "Not Logged In as User", 401

    return wrap


@app.route("/")
@app.route("/login")
def login():
    return render_template("login.html")

@app.route("/home")
def home():
    return render_template("index1.html")




@app.route("/register")
def register():
    return render_template("register.html")


@app.route("/profile")
def profile():
    return render_template("profile.html")

#here
@app.route('/pothole', methods=['POST'])
def pothole():
    if request.method == 'POST':
        values = request.get_json()
        print(values)

        values["lat"]
        values["long"]

        coor0 = (values["lat"], values["long"])
        response = pothole_db.potholes.find({"isFixed": False})
        flag=True
        for i in response:
            latd = i['geometry']['coordinates'][0]
            lond = i['geometry']['coordinates'][1]
            coor1 = (latd, lond)
            dist= geopy.distance.geodesic(coor0, coor1).m
            print(dist)
            if dist<=25:
                if i["reporter_address"] != values["account-address"]:
                    pothole_db.potholes.find_one_and_update({"_id": i["_id"]}, {"$set": {"priority": i["priority"]+1}})
                    flag=False
                else:
                    flag=False
                    message = "Pothole already exists"
                    return message, 401

        if flag:
            a = {
                "_id": uuid.uuid4().hex,
                "type": "Feature",
                "geometry": {
                        "type": "Point",
                        "coordinates": [float(values["lat"]), float(values["long"])]
                            },
                "properties": {
                "road": values["road"],
                "city": values["city"],
                "locality": values["locality"],
                "postal_code": values["postcode"]
                },
                'reporter_address' : values["account-address"],
                'path': values["hash"],
                'isFixed': False,
                'fixed_path': None,
                'transaction_hash': None,
                "priority": 0
            }

            pothole_db.potholes.insert_one(a)

            user = db.users.find_one({
                "account-address": values['account-address']
            })
            db.users.find_one_and_update({"account-address": values["account-address"]},
                                         {"$set": {"tokens": user["tokens"] + 1}})


            message = a["_id"]
            return message, 201
        else:
            message = "Pothole already exists"
            return message, 401

    message = "No Data"
    return message, 406


@app.route("/potholes_coordinates")
def potholes_coordinates():
    response = pothole_db.potholes.find()
    arr = []
    for i in response:
        print(i)
        temp = [i["_id"], i["geometry"], i["properties"], i["path"], i["reporter_address"], i["isFixed"], i["transaction_hash"], i["fixed_path"], i["priority"]]
        arr.append(temp)
    arr = json.dumps(arr)
    return arr

@app.route("/notfixed_potholes_coordinates")
def notfixed_potholes_coordinates():
    response = pothole_db.potholes.find({ "isFixed": False })
    arr = []
    for i in response:
        print(i)
        temp = [i["_id"], i["geometry"], i["properties"], i["path"], i["reporter_address"], i["isFixed"], i["transaction_hash"], i["fixed_path"], i["priority"]]
        arr.append(temp)
    arr = json.dumps(arr)
    return arr

@app.route("/fixed_potholes_coordinates")
def fixed_potholes_coordinates():
    response = pothole_db.potholes.find({ "isFixed": True })
    arr = []
    for i in response:
        print(i)
        temp = [i["_id"], i["geometry"], i["properties"], i["path"], i["reporter_address"], i["isFixed"], i["transaction_hash"], i["fixed_path"], i["priority"]]
        arr.append(temp)
    arr = json.dumps(arr)
    return arr


@app.route("/userfixed_potholes_coordinates", methods=['POST'])
def userfixed_potholes_coordinates():
    if request.method == 'POST':
        values = request.get_json()
        response = pothole_db.potholes.find({"reporter_address": values["account-address"], "isFixed": True })
        arr = []
        for i in response:
            print(i)
            temp = [i["_id"], i["geometry"], i["properties"], i["path"], i["reporter_address"], i["isFixed"], i["transaction_hash"], i["fixed_path"], i["priority"]]
            arr.append(temp)
        arr = json.dumps(arr)
        return arr

@app.route("/usernotfixed_potholes_coordinates", methods=['POST'])
def usernotfixed_potholes_coordinates():
    if request.method == 'POST':
        values = request.get_json()
        response = pothole_db.potholes.find({"reporter_address": values["account-address"], "isFixed": False })
        arr = []
        for i in response:
            print(i)
            temp = [i["_id"], i["geometry"], i["properties"], i["path"], i["reporter_address"], i["isFixed"], i["transaction_hash"], i["fixed_path"], i["priority"]]
            arr.append(temp)
        arr = json.dumps(arr)
        return arr


@app.route("/user_potholes_coordinates", methods=['POST'])
def user_potholes_coordinates():
    if request.method == 'POST':
        values = request.get_json()
        response = pothole_db.potholes.find({"reporter_address": values["account-address"] })
        arr = []
        for i in response:
            print(i)
            temp = [i["_id"], i["geometry"], i["properties"], i["path"], i["reporter_address"], i["isFixed"], i["transaction_hash"], i["fixed_path"], i["priority"]]
            arr.append(temp)
        arr = json.dumps(arr)
        return arr


@app.route("/update/pothole_status", methods=['POST'])
def update_pothole_status():
    if request.method == 'POST':
        values = request.get_json()
        pothole_db.potholes.find_one_and_update({"_id": values["id"]}, {"$set": {"isFixed": True, "transaction_hash": values["transaction_hash"], "fixed_path": values["fixed_path"]}})
        return "Success", 200


@app.route("/user/test", methods=['POST'])
def user_test():
    if request.method == 'POST':
        req = request.get_json()
        imgstring = req["photo"]

        import base64
        imgdata = base64.b64decode(imgstring)
        filename = 'photo/imageToTest.png'
        with open(filename, 'wb') as f:
            f.write(imgdata)

        _, img = load_image(filename, resize_to=(299, 299))

        out_dict = mlmodel.predict({'image': img})
        print(out_dict)

        if out_dict["classLabel"] == "Pothole":
            api = ipfsApi.Client('https://ipfs.infura.io', 5001)
            res = api.add("photo/imageToTest.png")
            print(res[0]["Hash"])
            out_dict["Hash"]= res[0]["Hash"]


        os.remove("photo/imageToTest.png")

        return json.dumps(out_dict), 200

    message = "No Data"
    return message, 406


@app.route("/official/test", methods=['POST'])
def official_test():
    if request.method == 'POST':
        req = request.get_json()
        imgstring = req["photo"]

        import base64
        imgdata = base64.b64decode(imgstring)
        filename = 'photo/imageToTest.png'
        with open(filename, 'wb') as f:
            f.write(imgdata)

        _, img = load_image(filename, resize_to=(299, 299))

        out_dict = mlmodel.predict({'image': img})
        print(out_dict)

        if out_dict["classLabel"] == "Plain":
            api = ipfsApi.Client('https://ipfs.infura.io', 5001)
            res = api.add("photo/imageToTest.png")
            print(res[0]["Hash"])
            os.remove("photo/imageToTest.png")
            return json.dumps(res[0]["Hash"]), 200

        os.remove("photo/imageToTest.png")

        return json.dumps(out_dict), 200

    message = "No Data"
    return message, 406


@app.route('/accelerometer',methods=['POST'])
def accelerometer():
    values = request.get_json()

    # print(type(dict))
    # print(type(values['data']))
    # print(values['data'])
    # print("lol1")
    data = values['data']
    # print(len(data))
    # print(type(data))
    print("lol2")
    acc_z = []
    acc_y = []
    if len(data) == 0:
        return json.dumps([])
    for a in data:
        # print("owais is here")
        # print(a)
        acc_z.append(a['z'])
        acc_y.append(a['y'])

    print(acc_z)
    dictionary = {
        "rot_acc_z": acc_z,
        "rot_acc_y": acc_y
    }

    print("owaiscame here too")
    # # Serializing json
    # json_object = json.dumps(dictionary, indent=4)
    #
    # # Writing to sample.json
    # with open("plain-1.json", "w") as outfile:
    #     outfile.write(json_object)
    acc = [abs(acc_z[m]) * 0.7 + abs(acc_y[m]) * 0.3 for m in range(len(acc_z))]
    import matplotlib.pyplot as plt
    plt.plot(acc)
    plt.show()
    # print("acc:",acc)
    deviation = statistics.stdev(acc)
    print("deviaion",deviation)
    if deviation < 0.09:
        return json.dumps([])
    mean = statistics.mean(acc)
    print(mean)
    print("came here 1")
    z = []
    for i in range(0, len(acc)):
        z_score = (acc[i] - mean) / deviation
        z.append(z_score)
    index_z = []
    outliers = []
    print("came here 2")


    for i in range(0, len(z)):
        if z[i] > 3.5 or z[i] < -3.5:
            print("inside")
            index_z.append(i)
            outliers.append(z[i])
    # print(z)
    print(len(outliers))
    print(len(index_z))

    if(len(outliers)==0):
        return json.dumps([])
    if (len(index_z)==0):
        return json.dumps([])


    db_default = DBSCAN(eps=100, min_samples=3).fit(np.array(index_z).reshape(-1, 1))
    labels_z = db_default.labels_
    range_z = []
    print("came here 3")

    for val in set(labels_z):
        if val != -1:
            x = np.where(np.array(labels_z) == val)[0]
            range_z.append([index_z[x[0]], index_z[x[-1]]])
    print("came here 4")
    #
    # print(range_z)

    pothole_dict = []

    for rangeval in range_z:
        # print(data[rangeval[0]]['lat'])
        # print(data[rangeval[0]]['long'])
        # print(data[rangeval[1]]['lat'])
        # print(data[rangeval[1]]['long'])
        lat = (data[rangeval[0]]['lat'] + data[rangeval[1]]['lat'])/2
        long = (data[rangeval[0]]['long'] + data[rangeval[1]]['long'])/2
        #print(lat)
        #print(long)
        #print("\n\n")
        pothole = (lat,long)
        pothole_dict.append(pothole)

    returndata = {
        'pothole_ranges' : pothole_dict
    }
    print("hi1")
    ids=[]
    print(pothole_dict)
    from geopy.geocoders import Nominatim
    geolocator = Nominatim(user_agent="pothole")

    for i in pothole_dict:

        coor0 = (i[0], i[1])
        response = pothole_db.potholes.find({"isFixed": False})
        flag=True
        for j in response:
            latd = j['geometry']['coordinates'][0]
            lond = j['geometry']['coordinates'][1]
            coor1 = (latd, lond)
            dist= geopy.distance.geodesic(coor0, coor1).m
            if dist<=25:
                if j["reporter_address"] != values["account"]:
                    pothole_db.potholes.find_one_and_update({"_id": j["_id"]}, {"$set": {"priority": j["priority"]+1}})
                    flag=False
                    print("Pothole already exists")
                else:
                    flag=False
                    message = "Pothole already exists"
                    print(message)
        print(flag)
        if flag==True:
            #val = str(i[0]) + "," + str(i[1])
            print("inside")
            location = geolocator.reverse(i)
            if location:
                location= str(location)
                location= location.split(",")
            else:
                location=["unknown", "unknown", "unknown" ,"unknown" ,"unknown" , "unknown", "unknown", "unknown", "unknown", "unknown", "unknown"]

            a = {
                "_id": uuid.uuid4().hex,
                "type": "Feature",
                "geometry": {
                    "type": "Point",
                    "coordinates": [float(i[0]), float(i[1])]
                },
                "properties": {
                    "road": location[1][1:],
                    "city": location[-6][1:],
                    "locality": location[-4][1:],
                    "postal_code": location[-2][1:]
                },
                'reporter_address': values["account"],
                'path': "QmPAzP6wq7G4ZX8oa7do3uYdyKTyjJfXhw3D3oNKNBaHrg",
                'isFixed': False,
                'fixed_path': None,
                'transaction_hash': None,
                "priority": 0
            }

            pothole_db.potholes.insert_one(a)

            user = db.users.find_one({
                "account-address": values['account']
            })
            db.users.find_one_and_update({"account-address": values["account"]},
                                         {"$set": {"tokens": user["tokens"] + 1}})

            res = { "id": a["_id"],
                    "latitude": i[0],
                    "longitude": i[1],
                    "road": location[1][1:],
                    "city": location[-6][1:],
                    "locality": location[-4][1:],
                    "postal_code": location[-2][1:],
                    "path": "QmPAzP6wq7G4ZX8oa7do3uYdyKTyjJfXhw3D3oNKNBaHrg"
                    }
            ids.append(res)


    print(ids)
    return json.dumps(ids)


from user.routes import *
from official.routes import *


if __name__ == '__main__':
    app.run(port=2000, debug=True)
