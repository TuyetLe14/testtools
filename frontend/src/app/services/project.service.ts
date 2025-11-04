import { Injectable } from '@angular/core';
import { ApiService } from './api.service';
import { Observable } from 'rxjs';

export interface Project { id?: number; name: string; description?: string; owner_id?: number }

@Injectable({providedIn: 'root'})
export class ProjectService {
  constructor(private api: ApiService) {}
  list(userId?: number): Observable<Project[]> {
    const params = userId ? { user_id: userId } : undefined;
    return this.api.get<Project[]>('projects', params);
  }
}
