import { Component, signal, EventEmitter, Output  } from '@angular/core';
import { CommonModule } from '@angular/common';
import { LucideAngularModule } from 'lucide-angular';

@Component({
  selector: 'app-header',
  standalone: true,
  imports: [CommonModule, LucideAngularModule],
  templateUrl: './header.component.html',
  styleUrls: ['./header.component.css'],
  outputs: ['toggleSidebar'],
})
export class HeaderComponent {
  toggleSidebar = new EventEmitter<void>();
  isDark = signal(document.documentElement.classList.contains('dark'));
  onSearch(query: string) { /* emit or call service if needed */ }
  toggleTheme() {
    const now = !this.isDark();
    this.isDark.set(now);
    document.documentElement.classList.toggle('dark', now);
    localStorage.setItem('theme', now ? 'dark' : 'light');
  }
}
