from flask import Blueprint, request, jsonify
from ..services.project_service import ProjectService

bp = Blueprint('projects', __name__)

@bp.route('/', methods=['GET'])
def list_projects():
    user_id = request.args.get('user_id', type=int)
    if not user_id:
        return jsonify({'error':'user_id required as query param'}), 400
    projects = ProjectService.list_projects_for_user(user_id)
    return jsonify([{'id': p.id, 'name': p.name, 'description': p.description} for p in projects])

@bp.route('/', methods=['POST'])
def create_project():
    data = request.json or {}
    name = data.get('name')
    owner_id = data.get('owner_id')
    if not name or not owner_id:
        return jsonify({'error':'name and owner_id required'}), 400
    p = ProjectService.create_project(name, data.get('description'), owner_id)
    return jsonify({'id': p.id, 'name': p.name}), 201

@bp.route('/<int:project_id>', methods=['GET'])
def get_project(project_id):
    p = ProjectService.get_project(project_id)
    if not p:
        return jsonify({'error':'not found'}), 404
    return jsonify({'id':p.id,'name':p.name,'description':p.description,'owner_id':p.owner_id})
