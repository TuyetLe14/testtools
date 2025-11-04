from . import db
from datetime import datetime

class User(db.Model):
    __tablename__ = 'users'
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(64), unique=True, nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    password_hash = db.Column(db.String(128), nullable=False)
    role = db.Column(db.String(20), nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)

class Project(db.Model):
    __tablename__ = 'projects'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(140), nullable=False)
    description = db.Column(db.Text)
    owner_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    owner = db.relationship('User')

class TestPlan(db.Model):
    __tablename__ = 'test_plans'
    id = db.Column(db.Integer, primary_key=True)
    project_id = db.Column(db.Integer, db.ForeignKey('projects.id'))
    name = db.Column(db.String(140))
    description = db.Column(db.Text)

class TestSuite(db.Model):
    __tablename__ = 'test_suites'
    id = db.Column(db.Integer, primary_key=True)
    plan_id = db.Column(db.Integer, db.ForeignKey('test_plans.id'))
    name = db.Column(db.String(140))
    description = db.Column(db.Text)

class TestCase(db.Model):
    __tablename__ = 'test_cases'
    id = db.Column(db.Integer, primary_key=True)
    suite_id = db.Column(db.Integer, db.ForeignKey('test_suites.id'))
    project_id = db.Column(db.Integer, db.ForeignKey('projects.id'))
    title = db.Column(db.String(200))
    description = db.Column(db.Text)
    steps = db.Column(db.Text)
    expected = db.Column(db.Text)
    priority = db.Column(db.String(10), default='medium')
    created_by = db.Column(db.Integer, db.ForeignKey('users.id'))
    created_at = db.Column(db.DateTime, default=datetime.utcnow)

class AutomationJob(db.Model):
    __tablename__ = 'automation_jobs'
    id = db.Column(db.Integer, primary_key=True)
    test_case_id = db.Column(db.Integer, db.ForeignKey('test_cases.id'))
    framework = db.Column(db.String(80))
    script_path = db.Column(db.String(255))
    last_run = db.Column(db.DateTime)
    status = db.Column(db.String(20), default='idle')

class PerformanceRun(db.Model):
    __tablename__ = 'performance_runs'
    id = db.Column(db.Integer, primary_key=True)
    project_id = db.Column(db.Integer, db.ForeignKey('projects.id'))
    name = db.Column(db.String(140))
    metrics = db.Column(db.Text)
    run_at = db.Column(db.DateTime, default=datetime.utcnow)
