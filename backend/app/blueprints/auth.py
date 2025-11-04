from flask import Blueprint, jsonify
from ..models import User
from .. import db

bp = Blueprint('auth', __name__)

@bp.route('/users', methods=['GET'])
def list_users():
    users = User.query.all()
    return jsonify([{'id':u.id,'username':u.username,'email':u.email,'role':u.role} for u in users])
