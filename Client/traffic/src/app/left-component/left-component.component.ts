import { Component, OnInit } from '@angular/core';
import { AppService } from '../app-component-service';

@Component({
  selector: 'app-left-component',
  templateUrl: './left-component.component.html',
  styleUrls: ['./left-component.component.css']
})
export class LeftComponentComponent implements OnInit {
  data:any;
 constructor(private _appService:AppService){}
  public pieChartLabels:string[] = ["All Requests", "Approved Requests"];
  public pieChartData:number[] = [];
  public pieChartType:string = 'doughnut';
  pieChartColors:any;
   ngOnInit(){
    this.pieChartColors = [ {'backgroundColor': [
      "#FF6384",
   "#4BC0C0"
   ]}];
     this._appService.getPieChartData().subscribe(res=>{
      this.pieChartData=[];
       this.data=res;
    this.pieChartData.push(this.data["All"]);
    this.pieChartData.push(this.data["Approved"])
    });
   }
  // events on slice click
  public chartClicked(e:any):void {
    console.log(e);
  }
 
 // event on pie chart slice hover
  public chartHovered(e:any):void {
    console.log(e);
  }
}
