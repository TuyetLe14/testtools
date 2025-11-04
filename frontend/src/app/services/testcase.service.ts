import { Injectable } from '@angular/core';
import { ApiService } from './api.service';
import { Observable } from 'rxjs';

export interface TestCasePayload {
  project_id: number;
  title: string;
  steps: string[]; 
  expected?: string;
  created_by?: number;
}

@Injectable({providedIn: 'root'})
export class TestcaseService {
  constructor(private api: ApiService) {}

  create(payload: TestCasePayload): Observable<any> {
    const body = {
      project_id: payload.project_id,
      title: payload.title,
      steps: JSON.stringify(payload.steps),
      expected: payload.expected,
      created_by: payload.created_by
    };
    return this.api.post('tests/cases', body);
  }
}
