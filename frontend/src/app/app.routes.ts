import { Routes } from '@angular/router';
import { DashboardComponent } from './pages/dashboard/dashboard';
import { ManualTestComponent } from './pages/manual-test/manual-test';
import { AutomationComponent } from './pages/automation/automation';
import { PerformanceComponent } from './pages/performance/performance';

export const routes: Routes = [
  { path: '', redirectTo: '/dashboard', pathMatch: 'full' },
  { path: 'dashboard', component: DashboardComponent },
  { path: 'manual-test', component: ManualTestComponent },
  { path: 'automation', component: AutomationComponent },
  { path: 'performance', component: PerformanceComponent },
];
