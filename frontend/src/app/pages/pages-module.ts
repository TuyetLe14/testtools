import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { DashboardComponent } from './dashboard/dashboard';
import { ManualTestComponent } from './manual-test/manual-test';
import { AutomationComponent } from './automation/automation';
import { PerformanceComponent } from './performance/performance';

@NgModule({
  declarations: [
    DashboardComponent,
    ManualTestComponent,
    AutomationComponent,
    PerformanceComponent
  ],
  imports: [
    CommonModule
  ],
  exports: [
    DashboardComponent,
    ManualTestComponent,
    AutomationComponent,
    PerformanceComponent
  ]
})
export class PagesModule { }
