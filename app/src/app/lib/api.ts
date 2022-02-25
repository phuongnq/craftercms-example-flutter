import {
  getDescriptor,
  parseDescriptor,
  getNavTree,
  urlTransform,
} from '@craftercms/content';
import { DescriptorResponse, NavigationItem } from '@craftercms/models';
import { map, switchMap } from 'rxjs';

export function getModel(path = '/site/website/index.xml') {
  return getDescriptor(path, { flatten: true }).pipe(
    map((descriptor: (DescriptorResponse | DescriptorResponse[])) => parseDescriptor(descriptor))
    // Can use this for debugging purposes.
    // tap(console.log)
  )
}

export function getModelByUrl(webUrl = '/') {
  return urlTransform('renderUrlToStoreUrl', webUrl).pipe(
    switchMap((path: string) => getDescriptor(path, { flatten: true }).pipe(
      map((descriptor: (DescriptorResponse | DescriptorResponse[])) => parseDescriptor(descriptor, { parseFieldValueTypes: true }))
    ))
  );
}

export function getNav() {
  return getNavTree('/site/website', 1).pipe(
    // Flatten the nav so that home shows at the same level as the children.
    map((navigation: NavigationItem) => [
      {
        label: navigation.label,
        url: navigation.url,
        active: navigation.active,
        attributes: navigation.attributes
      },
      ...navigation.subItems,
    ])
  );
}