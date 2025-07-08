export  class GlobalContext {
  private static instance: GlobalContext;
  private objectMaps = new Map<string, Object>();

  private constructor() {
  }

  public static getContext(): GlobalContext {
    if (!GlobalContext.instance) {
      GlobalContext.instance = new GlobalContext();
    }
    return GlobalContext.instance;
  }

  getValue(value: string): Object {
    return this.objectMaps.get(value);
  }

  setValue(key: string, objectClass: Object): void {
    this.objectMaps.set(key, objectClass);
  }
}