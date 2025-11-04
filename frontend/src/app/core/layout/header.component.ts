import { Component, signal, EventEmitter, Output  } from '@angular/core';
import { CommonModule } from '@angular/common';
import { LucideAngularModule } from 'lucide-angular';

@Component({
  selector: 'app-header',
  standalone: true,
  imports: [CommonModule, LucideAngularModule],
  template: `
  <header class="flex items-center justify-between p-4 border-b dark:border-slate-700 bg-white dark:bg-slate-800">
    <div class="flex items-center gap-3">
      <button class="p-2 rounded hover:bg-slate-100 dark:hover:bg-slate-700" (click)="toggleSidebar.emit()">
        <lucide-icon name="menu"></lucide-icon>
      </button>
      <div class="text-lg font-semibold">Tester Hub</div>
    </div>

    <div class="flex items-center gap-4">
      <input type="text" placeholder="Search..." class="px-3 py-2 rounded border dark:border-slate-700 bg-slate-50 dark:bg-slate-900" (input)="onSearch($any($event.target).value)"/>
      <button (click)="toggleTheme()" class="p-2 rounded hover:bg-slate-100 dark:hover:bg-slate-700">
        <lucide-icon [name]="isDark() ? 'sun' : 'moon'"></lucide-icon>
      </button>
      <div class="w-8 h-8 rounded-full bg-indigo-500 text-white flex items-center justify-center">TU</div>
    </div>
  </header>
  `,
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
