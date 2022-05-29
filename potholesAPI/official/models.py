from flask import Flask, jsonify, request, session, redirect
from passlib.hash import pbkdf2_sha256
from app import db
import uuid


class Official:

  def start_session(self, official):
    #del official['password']
    session['logged_in_official'] = True
    session['official'] = official
    return jsonify(official), 200

  def signup(self):
    values= request.get_json()

    official = {
      "_id": uuid.uuid4().hex,
      "name": values['name'],
      "email": values['email'],
      "account-address":values["account-address"],
      "ward-name":values["ward-name"],
      "phone-number":values["phone-number"]

      # "password": values['password']
    }

    # Encrypt the password
    #official['password'] = pbkdf2_sha256.encrypt(official['password'])

    # Check for existing email address
    if db.officials.find_one({"account-address": official['account-address']}):
      return jsonify({"error": "Account address already in use"}), 400

    if db.officials.insert_one(official):
      return self.start_session(official)

    return jsonify({"error": "Signup failed"}), 400



  def signout(self):
    session.clear()
    return redirect('/')

  def login(self):

    values = request.get_json()

    official = db.officials.find_one({
      "account-address": values['account-address']
    })

    if official: #and pbkdf2_sha256.verify(values['password'], official['password']):
      return self.start_session(official)

    return jsonify({"error": "Invalid Account"}), 401