import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { Observable, of } from 'rxjs';
import { map, catchError, tap } from 'rxjs/operators';

@Injectable({
  providedIn: 'root'
})
export class AppService {

  constructor(private http: HttpClient) { }
  readonly endpoint = 'http://18.237.252.206:8080/';
  readonly httpOptions = {
    headers: new HttpHeaders({
      'Content-Type':  'application/json'
    })
  };
  private extractData(res: Response) {
    let body = res;
    return body || { };
  }
  login(email: string, password: string): string{
    return "200";
    // this.http.post<any>('https://'+ this.endpoint+'.in/api/login', {
    //   email: email,
    //   password: password
    // });
  }
  getCategories():void{}

  postReview():void{}

  getPending():void{}

  getHistory():void{}

  getLatLng():void{}

  postSignUp():void{}

  postLogin():void{}
}