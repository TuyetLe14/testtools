import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { DashboardComponent } from './dashboard/dashboard';
import { ManualTestComponent } from './manual-test/manual-test';
import { AutomationComponent } from './automation/automation';
import { PerformanceComponent } from './performance/performance';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';

@NgModule({
  declarations: [
    DashboardComponent,
    ManualTestComponent,
    AutomationComponent,
    PerformanceComponent
  ],
  imports: [
    CommonModule,
    FormsModule,
    ReactiveFormsModule
  ],
  exports: [
    DashboardComponent,
    ManualTestComponent,
    AutomationComponent,
    PerformanceComponent
  ]
})
export class PagesModule { }
