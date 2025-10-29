import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ApiService } from '../../services/api';

@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [CommonModule], 
  templateUrl: './dashboard.html',
  styleUrls: ['./dashboard.css']
})
export class DashboardComponent implements OnInit {
  projects: any[] = [];

  constructor(private api: ApiService) {}

  ngOnInit(): void {
    this.api.getProjects().subscribe(r => this.projects = r || []);
  }
}
