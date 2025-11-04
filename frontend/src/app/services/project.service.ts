import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

export interface ProjectPayload {
  id?: number;
  name: string;
  description?: string;
  owner_id?: number;
}

@Injectable({
  providedIn: 'root'
})
export class ProjectService {
  private apiUrl = 'http://localhost:5000/api/projects'; // ✅ Flask endpoint gốc

  constructor(private http: HttpClient) {}

  getAll(): Observable<ProjectPayload[]> {
    return this.http.get<ProjectPayload[]>(`${this.apiUrl}`);
  }

  getById(id: number): Observable<ProjectPayload> {
    return this.http.get<ProjectPayload>(`${this.apiUrl}/${id}`);
  }

  create(payload: ProjectPayload): Observable<ProjectPayload> {
    return this.http.post<ProjectPayload>(`${this.apiUrl}`, payload);
  }

  update(id: number, payload: ProjectPayload): Observable<ProjectPayload> {
    return this.http.put<ProjectPayload>(`${this.apiUrl}/${id}`, payload);
  }

  delete(id: number): Observable<void> {
    return this.http.delete<void>(`${this.apiUrl}/${id}`);
  }
}
