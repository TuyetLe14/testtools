import { NgModule } from '@angular/core';
import { RouterModule } from '@angular/router';
import { DashboardComponent } from './dashboard/dashboard';
import { ManualTestComponent } from './manual-test/manual-test';
import { AutomationComponent } from './automation/automation';
import { PerformanceComponent } from './performance/performance';

@NgModule({
  imports: [
    RouterModule,
    DashboardComponent,
    ManualTestComponent,
    AutomationComponent,
    PerformanceComponent
  ],
  exports: [
    DashboardComponent,
    ManualTestComponent,
    AutomationComponent,
    PerformanceComponent
  ]
})
export class PagesModule {}
