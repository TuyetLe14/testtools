import os
from flask import Flask, jsonify
from flask_sqlalchemy import SQLAlchemy
from .config import Config

db = SQLAlchemy()

def create_app(config_class=Config):
    app = Flask(__name__, static_folder=None)
    app.config.from_object(config_class)
    db.init_app(app)

    from .blueprints.projects import bp as projects_bp
    from .blueprints.tests import bp as tests_bp
    from .blueprints.auth import bp as auth_bp

    app.register_blueprint(auth_bp, url_prefix='/api/auth')
    app.register_blueprint(projects_bp, url_prefix='/api/projects')
    app.register_blueprint(tests_bp, url_prefix='/api/tests')

    @app.route('/api/health')
    def health():
        return jsonify({'status':'ok'})

    with app.app_context():
        try:
            db.create_all()
        except Exception:
            pass

    return app
