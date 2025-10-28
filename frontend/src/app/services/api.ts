import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class ApiService {
  private BASE_URL = 'http://127.0.0.1:5000/api'; // Flask backend

  constructor(private http: HttpClient) { }

  getProjects(): Observable<any> {
    return this.http.get(`${this.BASE_URL}/projects`);
  }

  createTestCase(data: any): Observable<any> {
    return this.http.post(`${this.BASE_URL}/testcases`, data);
  }

  runManualTest(id: number): Observable<any> {
    return this.http.post(`${this.BASE_URL}/run/manual/${id}`, {});
  }

  runAutomation(): Observable<any> {
    return this.http.post(`${this.BASE_URL}/run/automation`, {});
  }

  runPerformance(): Observable<any> {
    return this.http.post(`${this.BASE_URL}/run/performance`, {});
  }
}
