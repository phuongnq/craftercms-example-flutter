import { Component } from '@angular/core';
import { crafterConf } from '@craftercms/classes';
import { environment } from '../environments/environment';

import { getNav } from './lib/api';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  title = 'CrafterCMS + Angular Sample';
  copyright = `@CrafterCMS ${new Date().getFullYear()}`;
  navItems: any[] = [];

  constructor() {
    crafterConf.configure({
      baseUrl: environment.PUBLIC_CRAFTERCMS_HOST_NAME ?? '',
      site: environment.PUBLIC_CRAFTERCMS_SITE_NAME ?? '',
      cors: true,
    });

    getNav().subscribe(navItems => {
      this.navItems = navItems;
    });
  }
}
