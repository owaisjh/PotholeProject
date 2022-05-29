from flask import Flask, request
from app import app
from user.models import User

@app.route('/user/signup', methods=['POST'])
def userSignup():
  return User().signup()

@app.route('/user/signout')
def userSignout():
  return User().signout()

@app.route('/user/login', methods=['POST'])
def userLogin():
  return User().login()


@app.route('/user/addCert', methods=['POST'])
def userAddCert():
  return User().addCert()

@app.route('/user/fetchCert', methods=['POST'])
def userFetchCert():
  return User().fetchCert()


@app.route('/user/getTokens', methods=['POST'])
def userGetTokens():
  return User().getTokens()
  
@app.route('/user/addTokens', methods=['POST'])
def userAddTokens():
  return User().addTokens()



