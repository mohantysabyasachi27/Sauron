import { Component, Inject, OnInit } from '@angular/core';
import { MAT_DIALOG_DATA } from '@angular/material';
import { AppService } from '../app-component-service';
export interface CategoryClass {
  categoryId: string;
  categoryTitle:string;
}
@Component({
  selector: 'app-my-dialog',
  templateUrl: './video-modal.component.html',
  styleUrls: ['./video-modal.component.css']
})
export class VideoModalComponent implements OnInit {
  modalTitle: string;
  dataG:any;
  selectedValue:any;
  link:any;
  isVideo:boolean;
  license:string;
  selectedComment:string;
  dropdown: CategoryClass[];
  constructor(@Inject(MAT_DIALOG_DATA) public data: any,private _appservice:AppService) {
    this.modalTitle = "Welcome to Review";
    this.dataG=data;
    this.link=this.dataG["link"];
    this.isVideo=this.dataG["isVideo"];
    this.license=this.data["license"];
  }
  ngOnInit(){
   this._appservice.getCategories().subscribe(res=>{this.dropdown=res});
  }
  OnReject(){
    console.log(this.selectedValue);
  this.dataG["status"]=0;
  this.dataG["details"]=this.selectedComment;
  this.dataG["category"]= this.dropdown[this.selectedValue-1]["categoryTitle"];
  this.dataG["categoryId"]=this.selectedValue;
  this._appservice.postReview(this.dataG).subscribe(res=>{console.log("b")});
  }
  OnApprove(){
    this.dataG["status"]=1;
    this.dataG["details"]=this.selectedComment;
    this.dataG["category"]= this.dropdown[this.selectedValue-1]["categoryTitle"];
    this.dataG["categoryId"]=this.selectedValue;
    this._appservice.postReview(this.dataG).subscribe(res=>
      {console.log("b");},
      (error)=>{console.log(error)}
    );
  }
}
