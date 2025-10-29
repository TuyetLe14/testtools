import { Component, OnInit } from '@angular/core';
import { ApiService } from '../../services/api';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms'; 
import { ReactiveFormsModule, FormBuilder, FormGroup, FormArray, Validators } from '@angular/forms';

@Component({
  selector: 'app-manual-test',
  standalone: true,
  imports: [CommonModule, FormsModule, ReactiveFormsModule],  
  templateUrl: './manual-test.html',
  styleUrls: [ './manual-test.css'],
})
export class ManualTestComponent implements OnInit {
  projects: any[] = [];
  selectedProjectId = 0;
  testcases: any[] = [];

  newTestForm!: FormGroup;

  constructor(private api: ApiService, private fb: FormBuilder) {}

  ngOnInit(): void {
    this.newTestForm = this.fb.group({
      title: ['', Validators.required],
      steps: this.fb.array([this.fb.control('', Validators.required)]),
    });

    this.api.getProjects().subscribe({
      next: (r) => (this.projects = r || []),
      error: (err) => console.error('Error loading projects', err),
    });
  }

  get steps(): FormArray {
    return this.newTestForm.get('steps') as FormArray;
  }

  addStep() {
    this.steps.push(this.fb.control('', Validators.required));
  }

  removeStep(i: number) {
    this.steps.removeAt(i);
  }

  createTest() {
    if (!this.selectedProjectId) {
      alert('Select project');
      return;
    }

    const data = {
      title: this.newTestForm.value.title,
      steps: this.newTestForm.value.steps,
      type: 'manual',
    };

    this.api.createTestCase(this.selectedProjectId, data).subscribe({
      next: () => {
        alert('Created test case');
        this.loadTests();
      },
      error: (err) => console.error('Error creating test case', err),
    });
  }

  loadTests() {
    if (!this.selectedProjectId) return;
    this.api.getTests(this.selectedProjectId).subscribe({
      next: (r) => (this.testcases = r || []),
      error: (err) => console.error('Error loading tests', err),
    });
  }

  runTest(tc: any) {
    this.api.runTest(tc.id).subscribe({
      next: (res) => alert('Test enqueued. Run id: ' + res.run_id),
      error: (err) => console.error('Error running test', err),
    });
  }

  onProjectChange(id: number) {
  this.selectedProjectId = id;
  this.loadTests();
 }

}
