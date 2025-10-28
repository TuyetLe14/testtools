import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ManualTest } from './manual-test';

describe('ManualTest', () => {
  let component: ManualTest;
  let fixture: ComponentFixture<ManualTest>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [ManualTest]
    })
    .compileComponents();

    fixture = TestBed.createComponent(ManualTest);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
