import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({ providedIn: 'root' })
export class ApiService {
  base = 'http://localhost:5000/api';

  constructor(private http: HttpClient) {}

  getProjects(): Observable<any[]> { return this.http.get<any[]>(`${this.base}/projects`); }
  createProject(data:any){ return this.http.post(`${this.base}/projects`, data); }

  getTests(projectId:number){ return this.http.get<any[]>(`${this.base}/projects/${projectId}/tests`); }
  createTestCase(projectId:number, data:any){ return this.http.post(`${this.base}/projects/${projectId}/tests`, data); }

  runTest(testId:number){ return this.http.post<any>(`${this.base}/tests/${testId}/run`, {}); }
  getRun(runId:number){ return this.http.get<any>(`${this.base}/runs/${runId}`); }
}
