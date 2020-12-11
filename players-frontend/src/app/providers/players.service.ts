import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';

@Injectable({
  providedIn: 'root'
})
export class PlayersService {

  constructor(private _http: HttpClient) { }

  async getPlayers(query: string, column: string, order: string, page_size: number, page_number: number) {
    const httpHeaders = new HttpHeaders({"Content-Type": "application/json"});
    const httpParams = new HttpParams()
      .set('query', query).set('sort_column', column).set('sort_order', order)
      .set('page_size', page_size.toString()).set('page_number', page_number.toString());
    return this._http.get('http://localhost:3000/api/v1/rush_stat', {headers: httpHeaders, params: httpParams}).toPromise();
  }

  ConvertToCSV(objArray: {}[], headerList: string[]) {
    let array = typeof objArray != 'object' ? JSON.parse(objArray) : objArray;
    let str = '';
    let row = 'S.No,';
    for (let index in headerList) {
     row += headerList[index] + ',';
    }
    row = row.slice(0, -1);
    str += row + '\r\n';
    for (let i = 0; i < array.length; i++) {
     let line = (i+1)+'';
     for (let index in headerList) {
      let head = headerList[index];
      line += ',' + array[i][head];
     }
     str += line + '\r\n';
    }
    return str;
   }

   downloadFile(data: any, filename='data') {
    let csvData = this.ConvertToCSV(data, ['Player', 'Team', 'Pos', 'Att', 'Att/G', 'Yds', 'Avg',	'Yds/G', 'TD', 'Lng', '1st', '1st%', '20+',	'40+', 'FUM']);
    let blob = new Blob(['\ufeff' + csvData], { type: 'text/csv;charset=utf-8;' });
    let dwldLink = document.createElement("a");
    let url = URL.createObjectURL(blob);
    let isSafariBrowser = navigator.userAgent.indexOf('Safari') != -1 && navigator.userAgent.indexOf('Chrome') == -1;
    if (isSafariBrowser) {  //if Safari open in new window to save file with random filename.
        dwldLink.setAttribute("target", "_blank");
    }
    dwldLink.setAttribute("href", url);
    dwldLink.setAttribute("download", filename + ".csv");
    dwldLink.style.visibility = "hidden";
    document.body.appendChild(dwldLink);
    dwldLink.click();
    document.body.removeChild(dwldLink);
}
}
