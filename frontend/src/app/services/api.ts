import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class ApiService {
  private BASE = 'http://localhost:5000/api';

  constructor(private http: HttpClient) { }

  getProjects(): Observable<any> {
    return this.http.get(`${this.BASE}/projects`);
  }

  createProject(data:any): Observable<any> {
    return this.http.post(`${this.BASE}/projects`, data);
  }

  createTestCase(projectId:number, data:any): Observable<any> {
    return this.http.post(`${this.BASE}/projects/${projectId}/tests`, data);
  }

  getTests(projectId:number): Observable<any> {
    return this.http.get(`${this.BASE}/projects/${projectId}/tests`);
  }

  runTest(testId:number): Observable<any> {
    return this.http.post(`${this.BASE}/tests/${testId}/run`, {});
  }

  getRun(runId:number): Observable<any> {
    return this.http.get(`${this.BASE}/runs/${runId}`);
  }
}
