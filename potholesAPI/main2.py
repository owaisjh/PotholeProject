from flask import Flask, render_template, request
import os
import webbrowser
import threading
import json

import shutil


from driver_codes.AnalyticalTool.dataBaseCreation import dataBaseCreation
from driver_codes.AnalyticalTool.analysis import analyser
from driver_codes.AnalyticalTool.allSncs import allSncs
from driver_codes.AnalyticalTool.listIncarnation import listIncarnation
from driver_codes.AnalyticalTool.trackIncarnationRC import trackIncarnationRC


#pyinstaller --onefile --add-data "templates;templates" --add-data "static;static"  main.py --icon=favicon.ico


app = Flask(__name__)



@app.route("/")
@app.route("/home")
def home():
    return render_template("index.html")

@app.route("/faq")
def faq():
    return render_template("faq.html")



@app.route('/list_incarnations', methods = ['GET','POST'])
def list_incarnations():
    if not os.path.exists('data.json'):
        return render_template("error.html", message="Database has not been Initialized")

    if request.method =='POST':
        origin_name = request.form.get("origin_name")
        snc_name = request.form.get("snc_name")
        final_output=listIncarnation(origin_name, snc_name)

        return render_template("logs.html", len=len(final_output), logs=final_output)





    file = open("vms.json")
    nodes = json.load(file)


    file = open("sncs.json")
    sncs = json.load(file)

    return render_template("listIncarnations.html", nodes=nodes, len_nodes=len(nodes), sncs=sncs, len_sncs=len(sncs))

@app.route('/track_incarnation_R_C', methods = ['GET','POST'])
def track_incarnation_R_C():
    if not os.path.exists('data.json'):
        return render_template("error.html", message="Database has not been Initialized")

    if request.method =='POST':
        snc_name = request.form.get("snc_name")
        origin_name=request.form.get("origin_name")
        incarnation_number = request.form.get("incarnation_number")
        final_output=trackIncarnationRC(origin_name, snc_name, incarnation_number)

        return render_template("logs.html", len=len(final_output), logs=final_output)


    file = open("vms.json")
    nodes = json.load(file)


    file = open("sncs.json")
    sncs = json.load(file)

    return render_template("trackIncarnationRC.html" , nodes=nodes, len_nodes=len(nodes), sncs=sncs, len_sncs=len(sncs))




@app.route('/list_sncs')
def list_sncs():
    if not os.path.exists('data.json'):
        return render_template("error.html", message="Database has not been Initialized")

    file = open("sncs.json")
    final = json.load(file)

    return render_template("logs.html",len=len(final), logs=final)




@app.route("/database_create",  methods = ['GET','POST'])
def databaseCreate():
    if request.method =='POST':
        file = request.files['file']

        if file:
            #removing pre existing data
            shutil.rmtree("uploads", ignore_errors=True)
            try:
                os.remove("data.db")
            except OSError:
                pass

            try:
                os.remove("data.json")
            except OSError:
                pass

            try:
                os.remove("vms.json")
            except OSError:
                pass


            os.system("mkdir uploads")
            file.save("uploads/data.zip")

            import zipfile
            with zipfile.ZipFile("uploads/data.zip", "r") as zip_ref:
                zip_ref.extractall("uploads/data")

            dataBaseCreation()

            allSncsList = allSncs()
            a_file = open("sncs.json", "w")
            json.dump(allSncsList, a_file)
            a_file.close()


            return render_template("success.html", message="Database has been Initialized Successfully!")

    return render_template('database_create.html')


@app.route("/database_flush",  methods = ['GET','POST'])
def databaseFlush():
    if request.method =='POST':

        shutil.rmtree("uploads", ignore_errors=True)
        try:
            os.remove("data.db")
        except OSError:
            pass

        try:
            os.remove("data.json")
        except OSError:
            pass

        try:
            os.remove("vms.json")
        except OSError:
            pass

        return render_template("success.html", message="Database has been Flushed Successfully!")

    return render_template('database_flush.html')

@app.route("/tracer",  methods = ['GET','POST'])
def tracer():
    if not os.path.exists('data.json'):
        return render_template("error.html", message="Database has not been Initialized")


    if request.method =='POST':

        snc_name= request.form.get("snc_name")
        linedn_node1= request.form.get("linedn_node1")
        linedn_node2= request.form.get("linedn_node2")
        final_output = analyser(snc_name, linedn_node1, linedn_node2)
        return render_template("logs.html", len=len(final_output), logs=final_output)

    file = open("vms.json")
    nodes = json.load(file)

    file = open("sncs.json")
    sncs = json.load(file)

    return render_template('tracer.html' , nodes=nodes, len_nodes=len(nodes), sncs=sncs, len_sncs=len(sncs))




if __name__ == '__main__':
    url="http://127.0.0.1:5000/"
    port=5000
    threading.Timer(1.25, lambda: webbrowser.open(url)).start()
    app.run(port=port, debug=False)