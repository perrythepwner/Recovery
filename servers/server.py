import os
import subprocess
import signal
import json
import time
from dataclasses import dataclass
from threading import Lock, Thread
from typing import Any, Dict, Tuple
from uuid import uuid4

import requests
from flask import Flask, Response, redirect, request
from flask_cors import CORS, cross_origin

app = Flask(__name__)
CORS(app)

SERVER_PORT = os.getenv("SERVER_PORT", "8080")

@app.route("/env/<string:var>", methods=["GET"])
@cross_origin()
def getenv(var):
    value = os.getenv(var)
    # @to-do: is this secure for flag?
    return (value, 200) if value else ("env var not found", 404)

@app.route("/getaddressbalance/<string:address>", methods=["GET"])
@cross_origin()
def getbalance(address):
    return subprocess.check_output(["electrum", "--regtest", "getaddressbalance", address])

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=SERVER_PORT)
