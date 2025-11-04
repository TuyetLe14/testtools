import { Component } from '@angular/core';
import { SidebarComponent } from './sidebar.component';
import { HeaderComponent } from './header.component';
import { RouterOutlet } from '@angular/router';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-layout',
  standalone: true,
  imports: [CommonModule, SidebarComponent, HeaderComponent, RouterOutlet],
  template: `
  <div class="flex h-screen">
    <div class="w-[var(--sidebar-width)]">
      <app-sidebar></app-sidebar>
    </div>
    <div class="flex-1 flex flex-col">
      <app-header></app-header>
      <main class="p-6 overflow-auto bg-slate-50 dark:bg-slate-900">
        <router-outlet></router-outlet>
      </main>
    </div>
  </div>
  `
})
export class LayoutComponent {}
