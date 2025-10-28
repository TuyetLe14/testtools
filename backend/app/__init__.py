from flask import Flask
from flask_cors import CORS
from .models import db
from .api import api

def create_app():
    app = Flask(__name__)
    app.config["SQLALCHEMY_DATABASE_URI"] = "postgresql://tester:tester123@db:5432/testtools"
    app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

    db.init_app(app)
    CORS(app)
    app.register_blueprint(api, url_prefix="/api")

    with app.app_context():
        db.create_all()

    return app
