import { Component, OnInit } from '@angular/core';
import { ApiService } from '../../services/api';
import { CommonModule } from '@angular/common';
import { ReactiveFormsModule, FormBuilder, FormGroup, FormArray, Validators } from '@angular/forms';

@Component({
  selector: 'app-manual-test',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule],
  templateUrl: './manual-test.component.html',
  styleUrl: './manual-test.component.css',
})
export class ManualTestComponent implements OnInit {
  projects: any[] = [];
  selectedProjectId = 0;
  testcases: any[] = [];

  newTestForm!: FormGroup;

  constructor(private api: ApiService, private fb: FormBuilder) {}

  ngOnInit(): void {
    // ✅ Khởi tạo FormGroup với FormArray
    this.newTestForm = this.fb.group({
      title: ['', Validators.required],
      steps: this.fb.array([this.fb.control('', Validators.required)]),
    });

    // ✅ Gọi API load project
    this.api.getProjects().subscribe({
      next: (r) => (this.projects = r || []),
      error: (err) => console.error('Error loading projects', err),
    });
  }

  // ✅ Getter để truy cập FormArray steps
  get steps(): FormArray {
    return this.newTestForm.get('steps') as FormArray;
  }

  // ✅ Thêm 1 step mới
  addStep() {
    this.steps.push(this.fb.control('', Validators.required));
  }

  // ✅ Xoá 1 step
  removeStep(i: number) {
    this.steps.removeAt(i);
  }

  // ✅ Tạo test case mới
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

  // ✅ Load danh sách test case
  loadTests() {
    if (!this.selectedProjectId) return;
    this.api.getTests(this.selectedProjectId).subscribe({
      next: (r) => (this.testcases = r || []),
      error: (err) => console.error('Error loading tests', err),
    });
  }

  // ✅ Run test case
  runTest(tc: any) {
    this.api.runTest(tc.id).subscribe({
      next: (res) => alert('Test enqueued. Run id: ' + res.run_id),
      error: (err) => console.error('Error running test', err),
    });
  }
}
