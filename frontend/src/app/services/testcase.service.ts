import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

export interface TestCasePayload {
  project_id: number;
  title: string;
  steps: string[];
  created_by: number;
}

@Injectable({
  providedIn: 'root'
})
export class TestcaseService {
  private apiUrl = 'http://localhost:5000/api/tests';

  constructor(private http: HttpClient) {}

  getByProject(projectId: number): Observable<any[]> {
    return this.http.get<any[]>(`${this.apiUrl}/project/${projectId}`);
  }

  create(payload: TestCasePayload): Observable<any> {
    return this.http.post(`${this.apiUrl}/cases`, payload);
  }

  run(testcaseId: number): Observable<any> {
    return this.http.post(`${this.apiUrl}/run/${testcaseId}`, {});
  }
}
