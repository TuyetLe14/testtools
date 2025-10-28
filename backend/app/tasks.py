import os
from celery import Celery
from .models import TestCase, TestRun
from . import db
from datetime import datetime
import time

broker = os.getenv('CELERY_BROKER_URL', 'redis://redis:6379/0')
result_backend = os.getenv('CELERY_RESULT_BACKEND', broker)
celery_app = Celery('app_tasks', broker=broker, backend=result_backend)

@celery_app.task(bind=True)
def run_test_task(self, test_id):
    # simplistic demo runner
    with celery_app.app_context():
        tc = TestCase.query.get(test_id)
        # create or update a TestRun record (simple: find latest queued)
        tr = TestRun.query.filter_by(test_case_id=test_id, status='queued').order_by(TestRun.id.desc()).first()
        if tr:
            tr.status = 'running'
            tr.started_at = datetime.utcnow()
            db.session.commit()
        # simulate test run
        time.sleep(2)
        # sample result
        result = {'status':'passed','logs':'simulated run'}
        if tr:
            tr.status = 'passed'
            tr.finished_at = datetime.utcnow()
            tr.result = result
            db.session.commit()
        return result
