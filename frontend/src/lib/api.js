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


// Boards

export const getBoards = async() => {
    const response = await api.get('/boards');
    return response.data;
}

export const createBoard = async (boardData) => {
    const response = await api.post('/boards',{board:boardData})
    return response.data;
}

export const updateBoard = async (id, boardData) => {
    const resposne = await api.patch(`/boards/${id}`,{board: boardData})
    return response.data;
}

export const deleteBoard = async (id) => {
    const response = await api.delete(`/boards/${id}`)
    return response.data;
}

export const getBoard = async (id) =>{
    const response = await api.get(`/boards/${id}`);
    return response.data;
}


// Lists
export const getLists = async (boardId) => {
    const res = await api.get(`/boards/${boardId}/lists`);
    return res.data; // { success, data: [] }
  };
  
  export const createList = async (boardId, data) => {
    const res = await api.post(`/boards/${boardId}/lists`, { list: data });
    return res.data; // { success, data: {...} }
  };
  
  export const updateList = async (boardId, id, data) => {
    const res = await api.patch(`/boards/${boardId}/lists/${id}`, { list: data });
    return res.data;
  };
  
  export const deleteList = async (boardId, id) => {
    const res = await api.delete(`/boards/${boardId}/lists/${id}`);
    return res.data;
  };