from flask import Blueprint, jsonify, request, current_app
from . import db
from .models import Project, TestCase, TestRun
from .tasks import run_test_task
from datetime import datetime

bp = Blueprint('api', __name__)

@bp.route('/health')
def health():
    return jsonify({'status':'ok'})

# Projects
@bp.route('/projects', methods=['GET','POST'])
def projects():
    if request.method == 'POST':
        data = request.json or {}
        p = Project(name=data.get('name'), description=data.get('description'))
        db.session.add(p)
        db.session.commit()
        return jsonify({'id': p.id, 'name': p.name}), 201
    ps = Project.query.all()
    out = [{'id':p.id,'name':p.name,'description':p.description} for p in ps]
    return jsonify(out)

# Test cases
@bp.route('/projects/<int:pid>/tests', methods=['GET','POST'])
def tests(pid):
    if request.method == 'POST':
        data = request.json or {}
        tc = TestCase(project_id=pid, title=data.get('title'), type=data.get('type','manual'), steps=data.get('steps'))
        db.session.add(tc)
        db.session.commit()
        return jsonify({'id':tc.id,'title':tc.title}), 201
    tcs = TestCase.query.filter_by(project_id=pid).all()
    return jsonify([{'id':t.id,'title':t.title,'type':t.type,'steps':t.steps} for t in tcs])

# Run test (enqueue)
@bp.route('/tests/<int:test_id>/run', methods=['POST'])
def run_test(test_id):
    task = run_test_task.delay(test_id)
    # create TestRun record
    tr = TestRun(test_case_id=test_id, status='queued', started_at=None)
    db.session.add(tr)
    db.session.commit()
    return jsonify({'task_id': task.id, 'run_id': tr.id}), 202

@bp.route('/runs/<int:run_id>', methods=['GET'])
def get_run(run_id):
    tr = TestRun.query.get_or_404(run_id)
    return jsonify({
        'id': tr.id,
        'test_case_id': tr.test_case_id,
        'status': tr.status,
        'result': tr.result
    })
