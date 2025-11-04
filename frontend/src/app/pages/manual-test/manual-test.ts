import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormArray, FormBuilder, FormGroup, ReactiveFormsModule } from '@angular/forms';
import { ProjectService } from '../../services/project.service';
import { TestcaseService } from '../../services/testcase.service';

export interface TestCasePayload {
  project_id: number;
  title: string;
  steps: string[];
  created_by: number;
}

@Component({
  selector: 'app-manual-test',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule],
  templateUrl: './manual-test.html',
  styleUrl: './manual-test.css',
})
export class ManualComponent {
  form: FormGroup;

  projects: any[] = [];
  testcases: any[] = [];
  selectedProjectId: number | null = null;
  isLoading = false;

  constructor(
    private projectService: ProjectService,
    private testcase: TestcaseService,
    private fb: FormBuilder
  ) {
    this.form = this.fb.group({
      project_id: [''],
      title: [''],
      steps: this.fb.array([this.fb.control('Step 1')]),
    });
  }

  get steps(): FormArray {
    return this.form.get('steps') as FormArray;
  }

  onProjectChange(projectId: number) {
    this.selectedProjectId = projectId;
    this.loadTestcases(projectId);
  }

  loadTestcases(projectId: number) {
    this.isLoading = true;
    this.testcase.getByProject(projectId).subscribe({
      next: (data: any) => {
        this.testcases = data;
        this.isLoading = false;
      },
      error: (err: any) => {
        console.error('❌ Load testcases failed:', err);
        this.isLoading = false;
      },
    });
  }

  addStep() {
    this.steps.push(this.fb.control(`Step ${this.steps.length + 1}`));
  }

  removeStep(index: number) {
    this.steps.removeAt(index);
  }

  createTest() {
    const value = this.form.value;

    const payload: TestCasePayload = {
      project_id: Number(value.project_id ?? 0),
      title: value.title ?? '',
      steps: (value.steps ?? []).map((s: any) => s || ''),
      created_by: 1,
    };

    this.testcase.create(payload).subscribe({
      next: (res: any) => {
        console.log('✅ Test case created:', res);
        this.form.reset();
        this.form.setControl('steps', this.fb.array([this.fb.control('Step 1')]));
        if (this.selectedProjectId) this.loadTestcases(this.selectedProjectId);
      },
      error: (err: any) => console.error('❌ Create failed:', err),
    });
  }

  runTest(tc: any) {
    console.log('▶️ Running test case:', tc);
    alert(`Running test: ${tc.title}`);
  }

  ngOnInit() {
    this.projectService.getAll().subscribe({
      next: (res: any) => (this.projects = res),
      error: (err: any) => console.error('❌ Load projects failed:', err),
    });
  }
}
