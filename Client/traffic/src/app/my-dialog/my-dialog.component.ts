import { Component, Inject } from '@angular/core';
import { MAT_DIALOG_DATA } from '@angular/material';

@Component({
  selector: 'app-my-dialog',
  templateUrl: './my-dialog.component.html',
  styleUrls: ['./my-dialog.component.css']
})
export class MyDialogComponent  {
  modalTitle: string;
  dataG:any;
  constructor(@Inject(MAT_DIALOG_DATA) public data: any) {
    this.modalTitle = "Welcome to Review";
    this.dataG=data;
   // console.log(data)
  }

}