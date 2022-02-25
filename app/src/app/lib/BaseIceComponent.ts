import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { ContentInstance } from '@craftercms/models';
import { from, forkJoin } from 'rxjs';

// @ts-expect-error
import { fetchIsAuthoring, initInContextEditing, getICEAttributes }  from '@craftercms/experience-builder';

import { getModelByUrl } from './api';
import { environment } from '../../environments/environment';

@Component({
  template: ''
})

export class BaseIceComponent implements OnInit {
  public model: ContentInstance = {
    craftercms: {
      id: '',
      path: '',
      label: '',
      dateCreated: '',
      dateModified: '',
      contentTypeId: '',
    }
  };
  public baseUrl: string = environment.PUBLIC_CRAFTERCMS_HOST_NAME ?? '';
  path: string = '';

  constructor(router: Router) {
    this.path = router.url;
  }

  ngOnInit(): void {
    forkJoin({
      isAuthoring: from(fetchIsAuthoring()),
      model: getModelByUrl(this.path),
    }).subscribe(({ isAuthoring, model }) => {
      this.model = model instanceof Array ? model[0] : model;
      if (isAuthoring && this.model && this.model.craftercms) {
        initInContextEditing({
          path: this.model.craftercms.path,
        });
      }
    });
  }

  getIce(params: any) {
    const { model, index, fieldId } = params;
    return getICEAttributes({ model, fieldId, index });
  }
}