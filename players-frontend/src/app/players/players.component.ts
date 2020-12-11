import { ViewChild } from '@angular/core';
import { Component, OnInit } from '@angular/core';
import { MatPaginator, PageEvent } from '@angular/material/paginator';
import { MatSort } from '@angular/material/sort';
import { MatTableDataSource } from '@angular/material/table';
import { Player, PLAYER_KEYS } from '../models/player'
import { PlayersService } from '../providers/players.service';

const rushStatKeyValuePairs: {[k: string]: string} = {
  Yds: 'total_yards',
  TD: 'total_tochdowns',
  Lng: 'longest',
}

@Component({
  selector: 'app-players',
  templateUrl: './players.component.html',
  styleUrls: ['./players.component.scss']
})
export class PlayersComponent implements OnInit {

  players!: Player[];
  displayedColumns: string[] = PLAYER_KEYS;
  dataSource: MatTableDataSource<Player>;
  pageSize: number = 10;
  pageSizes: number[] = [10, 25, 50, 100];
  pageEvent!: PageEvent;
  length: number = 33;
  pageIndex: number = 0;
  sortColumn!: string;
  sortDirection!: string;
  filterValue: string = '*';
  loading: boolean = false;

  @ViewChild(MatPaginator)
  paginator!: MatPaginator;
  @ViewChild(MatSort)
  sort!: MatSort;
  
  constructor(private _playersService: PlayersService) {
    this.dataSource = new MatTableDataSource();
  }

  async ngOnInit() {
    await this.getPlayers("*", 'id', 'asc', this.pageSize, this.pageIndex);
  }

  ngAfterViewInit() {
  }

  initPaginatorAndSort() {
    this.dataSource.paginator = this.paginator as MatPaginator;
    this.dataSource.sort = this.sort as MatSort;
  }

  /**
   * @description getting users though PlayersService
   * @param query - filtering text
   * @param column - column to sort by
   * @param order 
   * @param page_size 
   * @param page_number 
   */
  async getPlayers(query: string = '*', column: string = 'id', order: string = 'asc', page_size: number = this.pageSize, page_number: number = this.pageIndex) {
    try {
      this.loading = true;
      const result = await this._playersService.getPlayers(query, column, order, page_size, page_number + 1) as {players: Player[], length: number};
      this.players = result.players;
      this.length = result.length;
      console.log(result);
      this.dataSource = new MatTableDataSource(this.players);
    } catch (err) {
      console.log(err);
    } finally {
      this.loading = false;
    }
  }

  /**
   * @description filters input
   * @param event - event from search input
   */
  async applyFilter(event: Event) {
    let filterValue = (event.target as HTMLInputElement).value;
    
    if (filterValue === '') {
      filterValue = '*';
    }
    this.filterValue = filterValue;
    this.pageSize = 10;
    this.pageIndex = 0;
    // this.dataSource.filter = filterValue.trim().toLowerCase();
    await this.getPlayers(filterValue, 'id', 'asc', this.pageSize, this.pageIndex)

    if (this.dataSource.paginator) {
      this.dataSource.paginator.firstPage();
      this.pageIndex = 0;
    }
  }

  /**
   * @description handles paginator click event
   * @param event - dom event on paginator
   */
  paginatorClick(event: PageEvent): PageEvent {
    console.log(event);
    let changeDetected: boolean = false;
    if (event.pageSize !== this.pageSize) {
      this.pageSize = event.pageSize;
      changeDetected = true;
    }
    if (event.pageIndex !== this.pageIndex) {
      this.pageIndex = event.pageIndex;
      changeDetected = true;
    }

    if (changeDetected) {
      console.log(this.pageIndex);
      this.getPlayers('*', this.sortColumn, this.sortDirection, this.pageSize, this.pageIndex);
    } else {
      console.log("No change detected");
    }
    return event;
  }

  /**
   * @description gets event on sort header click
   * @param event - dom event on sort header
   */
  sortData(event: {active: string, direction: string}) {
    console.log(event);
    this.sortColumn = rushStatKeyValuePairs[event.active];
    this.sortDirection = event.direction;
    if (this.sortDirection == '') {
      this.sortDirection = 'asc';
    }
    this.pageIndex = 0;
    this.getPlayers(this.filterValue, this.sortColumn, this.sortDirection, this.pageSize, this.pageIndex)
  }

  saveCurrentView() {
    console.log('save current view');
    this._playersService.downloadFile(this.players, `rush-stat-page-${this.pageIndex}`);
  }

  async saveAll() {
    console.log('save all');
    const filterValue = this.filterValue == '' ? '*' : this.filterValue;
    const sortColumn = this.sortColumn ? this.sortColumn : 'id';
    const sortDirection = this.sortDirection ? this.sortDirection : 'asc'
    const result = await this._playersService.getPlayers(filterValue, sortColumn, sortDirection, this.length, 1 ) as {players: Player[], length: number};
    console.log(result.players);
    this._playersService.downloadFile(result.players, `rush-stat-all`);
  }
}
