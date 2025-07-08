
import { Context } from '@kit.AbilityKit';
import { GlobalContext } from './GlobalContext';
import preferences from '@ohos.data.preferences';

export default class IndexedDBStorageController {
    private context = GlobalContext.getContext().getValue("context")
    private instance: preferences.Preferences =
        preferences.getPreferencesSync(this.context as Context, { name: 'parseDB' });

    private getObjKeys(obj: Object): string[] {
        let keys = Object.keys(obj);
        return keys;
    }

    public setItem(path: string, value: any) {
        this.instance.putSync(path, value);
        this.instance.flush();
    }

    public getItem(path: string) {
        if (this.instance.hasSync(path)) {
            return this.instance.getSync(path, {});
        }
        return undefined;
    }

    public removeItem(path: string) {
        if (this.instance.hasSync(path)) {
            this.instance.deleteSync(path);
            this.instance.flush();
        }
    }

    public getAllKeys() {
        let value = this.instance.getAllSync();
        return this.getObjKeys(value);
    }

    public clear() {
        this.instance.clearSync();
        this.instance.flush();
    }
}