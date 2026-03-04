declare module 'expo-router';
declare module '@expo/vector-icons';
declare module 'expo' {
  const _expo: any;
  export default _expo;
}

// Fallback shims to silence TS when React types aren't installed in the editor
declare module 'react';
declare module 'react/jsx-runtime';
