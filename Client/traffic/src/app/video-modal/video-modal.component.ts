import { Component, Inject } from '@angular/core';
import { MAT_DIALOG_DATA } from '@angular/material';
export interface Food {
  value: string;

}
@Component({
  selector: 'app-my-dialog',
  templateUrl: './video-modal.component.html',
  styleUrls: ['./video-modal.component.css']
})
export class VideoModalComponent  {
  modalTitle: string;
  dataG:any;
  selectedValue:any;
  dropdown: Food[] = [
    {value: 'steak-0'},
    {value: 'pizza-1'},
    {value: 'tacos-2'}
  ];
  constructor(@Inject(MAT_DIALOG_DATA) public data: any) {
    this.modalTitle = "Welcome to Review";
    this.dataG=data;
  }
  OnReject(){

  }
  OnApprove(){
    
  }
}
