import { NgModule } from '@angular/core';
import { RouterModule } from '@angular/router';
import { DashboardComponent } from './dashboard/dashboard';
import { ManualComponent } from './manual-test/manual-test';
import { AutomationComponent } from './automation/automation';
import { PerformanceComponent } from './performance/performance';

@NgModule({
  imports: [
    RouterModule,
    DashboardComponent,
    ManualComponent,
    AutomationComponent,
    PerformanceComponent
  ],
  exports: [
    DashboardComponent,
    ManualComponent,
    AutomationComponent,
    PerformanceComponent
  ]
})
export class PagesModule {}
