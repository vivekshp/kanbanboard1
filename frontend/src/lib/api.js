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

//Tasks
export const getTasks = (boardId, listId) =>
    api.get(`/boards/${boardId}/lists/${listId}/tasks`).then(r => r.data);
  
  export const createTask = (boardId, listId, attrs) =>
    api.post(`/boards/${boardId}/lists/${listId}/tasks`, { task: attrs }).then(r => r.data);
  
  export const updateTask = (boardId, listId, taskId, attrs) =>
    api.patch(`/boards/${boardId}/lists/${listId}/tasks/${taskId}`, { task: attrs }).then(r => r.data);
  
  export const deleteTask = (boardId, listId, taskId) =>
    api.delete(`/boards/${boardId}/lists/${listId}/tasks/${taskId}`).then(r => r.data);

  export const searchUsers = (q) => 
    api.get('/users/search', { params: { q } }).then(r => r.data);

  export const listMembers = (boardId) => 
    api.get(`/boards/${boardId}/members`).then(r => r.data);

  export const inviteMember = (boardId, { userId, role = 'member' }) =>
   api.post(`/boards/${boardId}/members`, { board_member: { user_id: userId, role } }).then(r => r.data);

  export const updateMember = (boardId, memberId, attrs) =>
   api.patch(`/boards/${boardId}/members/${memberId}`, attrs).then(r => r.data);

  export const removeMember = (boardId, memberId) =>
   api.delete(`/boards/${boardId}/members/${memberId}`).then(r => r.status === 204);

  //Invites
  export const getInvites = () =>
    api.get('/invites').then(r => r.data);
  
  export const respondInvite = (inviteId, status) =>
    api.patch(`/invites/${inviteId}`, { status }).then(r => r.data);
  
  export const deleteInvite = (inviteId) =>
    api.delete(`/invites/${inviteId}`).then(r => r.status === 204);

  export const assignTask = (boardId, listId, taskId, userId) =>
  api.post(`/boards/${boardId}/lists/${listId}/tasks/${taskId}/task_assignments`, {
    user_id: userId
  }).then(r => r.data);

  export const searchBoardMembers = (boardId, q) =>
  api.get('/users/search_board_members', { params: { board_id: boardId, q } }).then(r => r.data);

  export const globalSearch = (params) =>
  api.get('/search', { params }).then(r => r.data);

export const getAssignees = (params = {}) => {
  const searchParams = new URLSearchParams(params).toString();
  return api.get(`/assignees?${searchParams}`).then(r => r.data);
};

// histories
export const getHistories = (params = {}) =>
  api.get('/histories', { params }).then(r => r.data);
