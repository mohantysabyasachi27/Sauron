import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { Observable, of } from 'rxjs';
import { map, catchError, tap } from 'rxjs/operators';
import { PeriodicElement } from './PeriodicElement';

@Injectable({
  providedIn: 'root'
})
export class AppService {

  constructor(private http: HttpClient) { }
  readonly endpoint = 'http://35.196.69.61:8080/';
  readonly httpOptions = {
    headers: new HttpHeaders({
      'Content-Type':  'application/json'
    })
  };
  private extractData(res: Response) {
    let body = res;
    return body || { };
  }
  getCategories():Observable<any>{
   var k=this.endpoint+"category";
   return this.http.get(k).pipe(
    map(this.extractData)
  );
   }
 
  postReview(data:PeriodicElement):Observable<any>{
    var url=this.endpoint+"ticket"; 
    var body={
      "address":data["address"],
      "category":data["category"],
      "categoryId":data["categoryId"],
      "date":data["date"],
      "details":data["details"],
      "isVideo":data["isVideo"],
      "latitude":data["latitude"],
      "link":data["link"],
      "links":data["links"],
      "longitude":data["longitude"],
      "points":data["points"],
      "status":data["status"],
      "ticketId":data["ticketId"],
      "username":data["username"],
      "violationType":data["violationType"]
    };
    return this.http.put(url,body).pipe(
      map(this.extractData)
      );
  }

  getPending(UserId:string,newDate:string,TabIndex:number):Observable<any>{
   var isPending=(TabIndex==1) ?true:false;
  const params=new HttpParams()
  .set('adminUserId',UserId)
  .set('startDate',newDate)
  .set('isPending',isPending.toString());
  var k=this.endpoint+"ticket";
  return this.http.get(k,{params:params}).pipe(
    map(this.extractData)
  );
  }
  getPieChartData():Observable<any>{
    var url=this.endpoint+"ticket/aggregate";
    return this.http.get(url).pipe(
      map(this.extractData)
    );
  }

  getHistory(UserId:string,newDate:string,TabIndex:number):Observable<any>{
    var isPending=(TabIndex==2) ?true:false;
   const params=new HttpParams()
   .set('adminUserId',UserId)
   .set('startDate',newDate)
   .set('isPending',isPending.toString());
   var k=this.endpoint+"ticket";
   return this.http.get(k,{params:params}).pipe(
    map(this.extractData)
  );
   }
   getLatLng():void{}

  postSignUp():void{}

}