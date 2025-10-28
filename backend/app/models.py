from . import db
from datetime import datetime
import json

class Project(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(200), nullable=False)
    description = db.Column(db.Text)

class TestCase(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    project_id = db.Column(db.Integer, db.ForeignKey('project.id'))
    title = db.Column(db.String(300), nullable=False)
    type = db.Column(db.String(50), default='manual')  
    steps = db.Column(db.JSON)
    script_path = db.Column(db.String(1024))
    created_at = db.Column(db.DateTime, default=datetime.utcnow)

class TestRun(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    test_case_id = db.Column(db.Integer, db.ForeignKey('test_case.id'))
    status = db.Column(db.String(50), default='pending')  
    result = db.Column(db.JSON)
    started_at = db.Column(db.DateTime)
    finished_at = db.Column(db.DateTime)
