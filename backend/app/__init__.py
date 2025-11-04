import os
import sqlite3
from flask import Flask, jsonify
from flask_sqlalchemy import SQLAlchemy
from .config import Config

db = SQLAlchemy()

def create_app(config_class=Config):
    app = Flask(__name__, static_folder=None)
    app.config.from_object(config_class)

    if not app.config.get("SQLALCHEMY_DATABASE_URI"):
        base_dir = os.path.abspath(os.path.dirname(__file__))
        db_path = os.path.join(base_dir, "database.db")
        app.config["SQLALCHEMY_DATABASE_URI"] = f"sqlite:///{db_path}"
        app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

    db.init_app(app)

    from .blueprints.projects import bp as projects_bp
    from .blueprints.tests import bp as tests_bp
    from .blueprints.auth import bp as auth_bp

    app.register_blueprint(auth_bp, url_prefix="/api/auth")
    app.register_blueprint(projects_bp, url_prefix="/api/projects")
    app.register_blueprint(tests_bp, url_prefix="/api/tests")

    @app.route("/api/health")
    def health():
        return jsonify({"status": "ok"})

    with app.app_context():
        base_dir = os.path.abspath(os.path.dirname(__file__))
        db_path = os.path.join(base_dir, "database.db")

        if not os.path.exists(db_path):
            print("🧱 Creating new SQLite database...")
            from . import models
            db.create_all()

            sql_file = os.path.join(base_dir, "database_testcase.sql")
            if os.path.exists(sql_file):
                print(f"📥 Importing seed data from: {sql_file}")
                try:
                    conn = sqlite3.connect(db_path)
                    with open(sql_file, "r", encoding="utf-8") as f:
                        sql_script = f.read()
                        sql_script = sql_script.replace("GO", "")
                        conn.executescript(sql_script)
                    conn.close()
                    print("✅ Database seeded successfully.")
                except Exception as e:
                    print(f"⚠️ Error while importing SQL file: {e}")
            else:
                print("⚠️ No seed file (database_testcase.sql) found.")
        else:
            print(f"✅ Using existing database: {db_path}")

    return app
