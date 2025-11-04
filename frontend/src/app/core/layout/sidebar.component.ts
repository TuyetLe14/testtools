import { Component, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink, RouterLinkActive } from '@angular/router';
import { LucideAngularModule } from 'lucide-angular';

@Component({
  selector: 'app-sidebar',
  standalone: true,
  imports: [CommonModule, RouterLink, RouterLinkActive, LucideAngularModule],
  template: `
  <aside [class.w-64]="!collapsed()" [class.w-20]="collapsed()"
         class="bg-white dark:bg-slate-800 border-r dark:border-slate-700 h-full transition-all duration-300">
    <div class="flex items-center justify-between p-4 border-b dark:border-slate-700">
      <div class="flex items-center space-x-2">
        <div class="w-8 h-8 rounded bg-indigo-500 flex items-center justify-center text-white font-bold">TH</div>
        <div *ngIf="!collapsed()" class="text-lg font-semibold">Tester Hub</div>
      </div>
      <button (click)="toggle()" class="p-2 rounded hover:bg-slate-100 dark:hover:bg-slate-700">
        <lucide-icon name="menu"></lucide-icon>
      </button>
    </div>

    <nav class="p-3">
      <a routerLink="/" routerLinkActive="bg-slate-100 dark:bg-slate-700"
         class="flex items-center gap-3 p-2 rounded hover:bg-slate-100 dark:hover:bg-slate-700">
        <lucide-icon name="home"></lucide-icon>
        <span *ngIf="!collapsed()">Dashboard</span>
      </a>
      <a routerLink="/manual" routerLinkActive="bg-slate-100 dark:bg-slate-700"
         class="flex items-center gap-3 p-2 rounded hover:bg-slate-100 dark:hover:bg-slate-700 mt-1">
        <lucide-icon name="clipboard"></lucide-icon>
        <span *ngIf="!collapsed()">Manual Test</span>
      </a>
      <a routerLink="/tests" routerLinkActive="bg-slate-100 dark:bg-slate-700"
         class="flex items-center gap-3 p-2 rounded hover:bg-slate-100 dark:hover:bg-slate-700 mt-1">
        <lucide-icon name="cpu"></lucide-icon>
        <span *ngIf="!collapsed()">Automation</span>
      </a>
    </nav>
  </aside>
  `,
  styles: [`
    :host { display:block; height:100%; }
  `]
})
export class SidebarComponent {
  collapsed = signal(false);
  toggle() { this.collapsed.update(v => !v); }
}
