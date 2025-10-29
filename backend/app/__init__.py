from flask import Flask
from flask_cors import CORS

def create_app():
    app = Flask(__name__)
    CORS(app)

    # Absolute import
    from app.routes import api_bp  
    app.register_blueprint(api_bp, url_prefix="/api")

    @app.route("/")
    def index():
        return {"message": "Flask backend is running!"}

    return app
