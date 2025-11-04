from flask import Blueprint, jsonify, request, current_app
from . import db
from .models import Project, TestCase, TestRun
from datetime import datetime
import threading, time

bp = Blueprint('api', __name__)

def background_run(test_run_id, test_case_id):
    with current_app.app_context():
        tr = TestRun.query.get(test_run_id)
        tc = TestCase.query.get(test_case_id)
        if not tr or not tc:
            return
        tr.status = 'running'
        tr.started_at = datetime.utcnow()
        db.session.commit()

        steps = tc.steps or []
        logs = []
        for i, s in enumerate(steps, start=1):
            logs.append(f"Step {i}: {s} - OK")
            time.sleep(1) 

        result = {'status': 'passed', 'logs': logs}
        tr.status = 'passed'
        tr.result = result
        tr.finished_at = datetime.utcnow()
        db.session.commit()

@bp.route('/health', methods=['GET'])
def health():
    return jsonify({'status': 'ok'})

@bp.route('/projects', methods=['GET', 'POST'])
def projects():
    if request.method == 'POST':
        data = request.get_json() or {}
        name = data.get('name')
        if not name:
            return jsonify({'error': 'name required'}), 400
        p = Project(name=name, description=data.get('description'))
        db.session.add(p)
        db.session.commit()
        return jsonify({'id': p.id, 'name': p.name, 'description': p.description}), 201

    ps = Project.query.order_by(Project.id.desc()).all()
    out = [{'id': p.id, 'name': p.name, 'description': p.description} for p in ps]
    return jsonify(out)

@bp.route('/projects/<int:pid>/tests', methods=['GET', 'POST'])
def project_tests(pid):
    if request.method == 'POST':
        data = request.get_json() or {}
        title = data.get('title')
        if not title:
            return jsonify({'error': 'title required'}), 400
        steps = data.get('steps') or []
        tc = TestCase(project_id=pid, title=title, type=data.get('type','manual'), steps=steps)
        db.session.add(tc)
        db.session.commit()
        return jsonify({'id': tc.id, 'title': tc.title}), 201

    tcs = TestCase.query.filter_by(project_id=pid).order_by(TestCase.id.desc()).all()
    out = [{'id': t.id, 'title': t.title, 'type': t.type, 'steps': t.steps} for t in tcs]
    return jsonify(out)

@bp.route('/tests/<int:test_id>/run', methods=['POST'])
def run_test(test_id):
    tc = TestCase.query.get_or_404(test_id)
    tr = TestRun(test_case_id=test_id, status='queued')
    db.session.add(tr)
    db.session.commit()

    thread = threading.Thread(target=background_run, args=(tr.id, tc.id), daemon=True)
    thread.start()

    return jsonify({'run_id': tr.id, 'status': tr.status}), 202

@bp.route('/runs/<int:run_id>', methods=['GET'])
def get_run(run_id):
    tr = TestRun.query.get_or_404(run_id)
    return jsonify({
        'id': tr.id,
        'test_case_id': tr.test_case_id,
        'status': tr.status,
        'result': tr.result,
        'started_at': tr.started_at.isoformat() if tr.started_at else None,
        'finished_at': tr.finished_at.isoformat() if tr.finished_at else None
    })
