import { Component, EventEmitter, Output } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormArray, FormBuilder, FormGroup, ReactiveFormsModule, FormsModule } from '@angular/forms';

@Component({
  selector: 'app-test-case-form',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, FormsModule],
  templateUrl: './test-case-form.html',
  styleUrls: ['./test-case-form.css']
})
export class TestCaseFormComponent {
  @Output() submitForm = new EventEmitter<any>();

  form: FormGroup;

  constructor(private fb: FormBuilder) {
    this.form = this.fb.group({
      title: [''],
      description: [''],
      steps: this.fb.array([this.fb.control('')]),
      expected: [''],
      priority: ['medium']
    });
  }

  get steps(): FormArray {
    return this.form.get('steps') as FormArray;
  }

  addStep() {
    this.steps.push(this.fb.control(''));
  }

  removeStep(index: number) {
    this.steps.removeAt(index);
  }

  onSubmit() {
    const value = this.form.value;
    const payload = {
      title: value.title || '',
      description: value.description || '',
      steps: value.steps || [],
      expected: value.expected || '',
      priority: value.priority || 'medium'
    };
    this.submitForm.emit(payload);
    this.form.reset({ steps: [this.fb.control('')], priority: 'medium' });
  }
}
