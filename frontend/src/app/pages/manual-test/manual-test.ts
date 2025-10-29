import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule, ReactiveFormsModule, FormBuilder, FormArray, FormGroup } from '@angular/forms';
import { ApiService } from '../../services/api';

@Component({
  selector: 'app-manual-test',
  standalone: true,
  imports: [CommonModule, FormsModule, ReactiveFormsModule],
  templateUrl: './manual-test.html',
  styleUrls: ['./manual-test.css']
})
export class ManualTestComponent implements OnInit {
  projects: any[] = [];
  testcases: any[] = [];
  selectedProjectId = 0;
  newTestForm: FormGroup;

  constructor(private fb: FormBuilder, private api: ApiService) {
    this.newTestForm = this.fb.group({
      title: [''],
      steps: this.fb.array([this.fb.control('')])
    });
  }

  ngOnInit(){ this.api.getProjects().subscribe(r => this.projects = r || []); }

  get steps() { return this.newTestForm.get('steps') as FormArray; }
  addStep(){ this.steps.push(this.fb.control('')); }

  onProjectChange(id:number){ this.selectedProjectId = Number(id); this.loadTests(); }
  loadTests(){ if(!this.selectedProjectId) return; this.api.getTests(this.selectedProjectId).subscribe(r => this.testcases = r || []); }

  createTest(){
    if(!this.selectedProjectId) { alert('Select project'); return; }
    const payload = {...this.newTestForm.value, type:'manual'};
    this.api.createTestCase(this.selectedProjectId, payload).subscribe(() => { alert('Created'); this.loadTests(); });
  }

  runTest(tc:any){
    this.api.runTest(tc.id).subscribe((res:any) => { alert('Run queued. Task: ' + (res.task_id || res.taskId || res.task)); });
  }
}
