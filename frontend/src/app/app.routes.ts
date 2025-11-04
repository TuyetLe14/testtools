import { Routes } from '@angular/router';
import { DashboardComponent } from './pages/dashboard/dashboard';
import { ManualComponent } from './pages/manual-test/manual-test';
import { AutomationComponent } from './pages/automation/automation';
import { PerformanceComponent } from './pages/performance/performance';
import { LayoutComponent } from './core/layout/layout.component';

export const routes: Routes = [
  {
     path: '',
     component: LayoutComponent,
     children: [
      { path: '', redirectTo: '/dashboard', pathMatch: 'full' },
      { path: 'dashboard', component: DashboardComponent },
      { path: 'manual-test', component: ManualComponent },
      { path: 'automation', component: AutomationComponent },
      { path: 'performance', component: PerformanceComponent },
    ]
  }
];
