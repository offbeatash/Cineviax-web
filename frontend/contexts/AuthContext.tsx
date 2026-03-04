import React, { createContext, useState, useContext, useEffect } from 'react';
import * as SecureStore from 'expo-secure-store';
import axios from 'axios';

const API_URL = process.env.EXPO_PUBLIC_BACKEND_URL;

interface AuthContextType {
  user: any;
  loading: boolean;
  login: (email: string, password: string) => Promise<void>;
  signup: (email: string, password: string) => Promise<void>;
  logout: () => Promise<void>;
  token: string | null;
}

const AuthContext = createContext(undefined as unknown as AuthContextType | undefined);

export const AuthProvider = ({ children }: { children?: any }): any => {
  const [user, setUser] = useState(null as any);
  const [loading, setLoading] = useState(true);
  const [token, setToken] = useState(null as string | null);

  useEffect(() => {
    loadToken();
  }, []);

  const loadToken = async () => {
    try {
      // expo-secure-store can behave differently on web; provide a safe wrapper
      const storedToken = await (async () => {
        try {
          if (typeof (SecureStore as any).getItemAsync === 'function') {
            return await (SecureStore as any).getItemAsync('userToken');
          }
          if (typeof (SecureStore as any).getValueWithKeyAsync === 'function') {
            return await (SecureStore as any).getValueWithKeyAsync('userToken');
          }
        } catch (e) {
          console.warn('SecureStore get error, falling back to localStorage', e);
        }
        try {
          return window.localStorage.getItem('userToken');
        } catch {
          return null;
        }
      })();
      if (storedToken) {
        setToken(storedToken);
        setUser({ token: storedToken });
      }
    } catch (error) {
      console.error('Error loading token:', error);
    } finally {
      setLoading(false);
    }
  };

  const login = async (email: string, password: string) => {
    try {
      const response = await axios.post(`${API_URL}/api/login`, {
        email,
        password,
      });
      const { access_token } = response.data;
      try {
        if (typeof (SecureStore as any).setItemAsync === 'function') {
          await (SecureStore as any).setItemAsync('userToken', access_token);
        } else if (typeof (SecureStore as any).setValueWithKeyAsync === 'function') {
          await (SecureStore as any).setValueWithKeyAsync('userToken', access_token);
        } else {
          window.localStorage.setItem('userToken', access_token);
        }
      } catch (e) {
        console.warn('SecureStore set error, falling back to localStorage', e);
        try { window.localStorage.setItem('userToken', access_token); } catch {}
      }
      setToken(access_token);
      setUser({ token: access_token });
    } catch (error: any) {
      throw new Error(error.response?.data?.detail || 'Login failed');
    }
  };

  const signup = async (email: string, password: string) => {
    try {
      const response = await axios.post(`${API_URL}/api/signup`, {
        email,
        password,
      });
      const { access_token } = response.data;
      try {
        if (typeof (SecureStore as any).setItemAsync === 'function') {
          await (SecureStore as any).setItemAsync('userToken', access_token);
        } else if (typeof (SecureStore as any).setValueWithKeyAsync === 'function') {
          await (SecureStore as any).setValueWithKeyAsync('userToken', access_token);
        } else {
          window.localStorage.setItem('userToken', access_token);
        }
      } catch (e) {
        console.warn('SecureStore set error (signup), falling back to localStorage', e);
        try { window.localStorage.setItem('userToken', access_token); } catch {}
      }
      setToken(access_token);
      setUser({ token: access_token });
    } catch (error: any) {
      throw new Error(error.response?.data?.detail || 'Signup failed');
    }
  };

  const logout = async () => {
    try {
      if (typeof (SecureStore as any).deleteItemAsync === 'function') {
        await (SecureStore as any).deleteItemAsync('userToken');
      } else if (typeof (SecureStore as any).deleteValueWithKeyAsync === 'function') {
        await (SecureStore as any).deleteValueWithKeyAsync('userToken');
      } else {
        window.localStorage.removeItem('userToken');
      }
    } catch (e) {
      console.warn('SecureStore delete error, falling back to localStorage', e);
      try { window.localStorage.removeItem('userToken'); } catch {}
    }
    setToken(null);
    setUser(null);
  };

  return (
    <AuthContext.Provider value={{ user, loading, login, signup, logout, token }}>
      {children}
    </AuthContext.Provider>
  );
};

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
};