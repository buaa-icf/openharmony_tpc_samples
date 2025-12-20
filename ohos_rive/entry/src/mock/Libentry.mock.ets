const nativeMock: Record<string, Object> = {
  'add': (a: number, b: number) => {
    return a + b;
  },
};

export default nativeMock;