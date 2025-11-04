import { Component } from '@angular/core';
import { RouterOutlet, RouterLink, RouterLinkActive } from '@angular/router';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [CommonModule, RouterOutlet, RouterLink, RouterLinkActive],
  templateUrl: './app.html',
  styleUrls: ['./app.css'],
})
export class AppComponent {
  title = 'Tester Hub';
  menu = [
    { path: '/dashboard', label: 'Dashboard', icon: '📊' },
    { path: '/manual-test', label: 'Manual Test', icon: '🧪' },
    { path: '/automation', label: 'Automation', icon: '🤖' },
    { path: '/performance', label: 'Performance', icon: '⚡' },
  ];
}
