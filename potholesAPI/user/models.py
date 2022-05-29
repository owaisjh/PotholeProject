from flask import jsonify, request, session, redirect
from app import db
import uuid
from user.generateCert import generateCert
import os
import ipfsApi
class User:

  def start_session(self, user):
    #del user['password']
    session['logged_in_user'] = True
    session['user'] = user
    return jsonify(user), 200

  def signup(self):
    values= request.get_json()

    user = {
      "_id": uuid.uuid4().hex,
      "name": values['name'],
      "email": values['email'],
      "account-address": values["account-address"],
      "phone-number": values["phone-number"],
      "cert-path": None,
      "tokens": 0
      #"password": values['password']
    }

    # Encrypt the password
    #user['password'] = pbkdf2_sha256.encrypt(user['password'])

    # Check for existing email address
    if db.users.find_one({"account-address": user['account-address']}):
      return jsonify({"error": "Account address already in use"}), 400

    if db.users.insert_one(user):
      return self.start_session(user)

    return jsonify({"error": "Signup failed"}), 400



  def signout(self):
    session.clear()
    return redirect('/')

  def login(self):
    values = request.get_json()
    print(values)
    user = db.users.find_one({
      "account-address": values['account-address']
    })

    if user: # and pbkdf2_sha256.verify(values['password'], user['password']):
      return self.start_session(user)

    return jsonify({"error": "Invalid login credentials"}), 401

  def fetchCert(self):
    values = request.get_json()
    user = db.users.find_one({
      "account-address": values['account-address']
    })
    return jsonify(user["cert-path"])

  def addCert(self):
    values = request.get_json()
    user = db.users.find_one({
      "account-address": values['account-address']
    })

    if user["tokens"]>=200:
      generateCert(user["name"])

      api = ipfsApi.Client('https://ipfs.infura.io', 5001)
      res = api.add("user/cert.jpg")
      print(res[0]["Hash"])

      os.remove("user/cert.jpg")
      db.users.find_one_and_update({"account-address": values["account-address"]}, {"$set": {"cert-path": res[0]["Hash"]}})
      db.users.find_one_and_update({"account-address": values["account-address"]}, {"$set": {"tokens": user["tokens"]-200}})
      return "Success",201

    else:
      return "Not enough tokens", 401

  def getTokens(self):
    values = request.get_json()
    user = db.users.find_one({
      "account-address": values['account-address']
    })
    return jsonify(user["tokens"])

  def addTokens(self):
    values = request.get_json()
    user = db.users.find_one({
      "account-address": values['account-address']
    })
    db.users.find_one_and_update({"account-address": values["account-address"]}, {"$set": {"tokens": user["tokens"]+values["tokens"]}})
    return "Success",201

