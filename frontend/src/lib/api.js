import axios from 'axios';

export const api = axios.create({
    baseURL: 'http://localhost:3000',
    withCredentials:true,
    headers: {'Content-Type': 'application/json','Accept': 'application/json'},
})

export const register = async (userData) => {
    const response = await api.post('/auth/register', userData);
    return response.data;
}

export const login = async (userData) => {
    const response = await api.post('/auth/login', userData);
    return response.data;
}

export const logout = async () => {
    const response = await api.delete('/auth/logout');
    return response.data;
}

export const getCurrentUser = async () => {
    const response = await api.get('/auth/me');
    return response.data;
}