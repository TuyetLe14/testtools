import { ComponentFixture, TestBed } from '@angular/core/testing';

import { TestCaseForm } from './test-case-form';

describe('TestCaseForm', () => {
  let component: TestCaseForm;
  let fixture: ComponentFixture<TestCaseForm>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [TestCaseForm]
    })
    .compileComponents();

    fixture = TestBed.createComponent(TestCaseForm);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
