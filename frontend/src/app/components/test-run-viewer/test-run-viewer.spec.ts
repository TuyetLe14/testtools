import { ComponentFixture, TestBed } from '@angular/core/testing';

import { TestRunViewer } from './test-run-viewer';

describe('TestRunViewer', () => {
  let component: TestRunViewer;
  let fixture: ComponentFixture<TestRunViewer>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [TestRunViewer]
    })
    .compileComponents();

    fixture = TestBed.createComponent(TestRunViewer);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
