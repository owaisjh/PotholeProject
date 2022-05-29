from flask import Flask, request
from app import app
from official.models import Official

@app.route('/official/signup', methods=['POST'])
def officialSignup():
  return Official().signup()

@app.route('/official/signout')
def officialSignout():
  return Official().signout()

@app.route('/official/login', methods=['POST'])
def officialLogin():
  return Official().login()

