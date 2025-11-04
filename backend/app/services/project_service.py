from ..models import Project
from .. import db

class ProjectService:
    @staticmethod
    def create_project(name, description, owner_id):
        p = Project(name=name, description=description, owner_id=owner_id)
        db.session.add(p)
        db.session.commit()
        return p

    @staticmethod
    def list_projects_for_user(user_id):
        return Project.query.filter_by(owner_id=user_id).all()

    @staticmethod
    def get_project(project_id):
        return Project.query.get(project_id)
