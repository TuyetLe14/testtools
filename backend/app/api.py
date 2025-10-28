from flask import Blueprint, request, jsonify
from .models import db, Project, TestCase

api = Blueprint('api', __name__)

@api.route("/projects", methods=["GET", "POST"])
def projects():
    if request.method == "POST":
        data = request.get_json()
        p = Project(name=data["name"], description=data.get("description"))
        db.session.add(p)
        db.session.commit()
        return jsonify({"id": p.id, "name": p.name}), 201
    projects = Project.query.all()
    return jsonify([{"id": p.id, "name": p.name} for p in projects])

@api.route("/projects/<int:id>/tests", methods=["POST", "GET"])
def testcases(id):
    if request.method == "POST":
        data = request.get_json()
        t = TestCase(project_id=id, title=data["title"], steps=data["steps"])
        db.session.add(t)
        db.session.commit()
        return jsonify({"id": t.id, "title": t.title}), 201
    tests = TestCase.query.filter_by(project_id=id).all()
    return jsonify([{"id": t.id, "title": t.title, "steps": t.steps} for t in tests])
