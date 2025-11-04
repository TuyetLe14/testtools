from flask import Blueprint, request, jsonify
from .. import db
from ..models import TestCase

bp = Blueprint('tests', __name__)

@bp.route('/cases', methods=['GET'])
def list_cases():
    project_id = request.args.get('project_id', type=int)
    q = TestCase.query
    if project_id:
        q = q.filter_by(project_id=project_id)
    cases = q.all()
    return jsonify([{'id': c.id, 'title': c.title, 'priority': c.priority} for c in cases])

@bp.route('/cases', methods=['POST'])
def create_case():
    data = request.json or {}
    required = ['project_id','title']
    for r in required:
        if r not in data:
            return jsonify({'error':f'{r} required'}), 400
    c = TestCase(
        suite_id=data.get('suite_id'),
        project_id=data['project_id'],
        title=data['title'],
        description=data.get('description'),
        steps=data.get('steps'),
        expected=data.get('expected'),
        priority=data.get('priority','medium'),
        created_by=data.get('created_by')
    )
    db.session.add(c)
    db.session.commit()
    return jsonify({'id': c.id, 'title': c.title}), 201
