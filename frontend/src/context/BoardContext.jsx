import { createContext, useContext, useEffect, useState } from 'react';
import { useParams } from 'react-router-dom';
import { getBoard, getLists, createList, updateList, deleteList, getTasks, createTask, updateTask, deleteTask } from '../lib/api';

const BoardContext = createContext(null);

export function BoardProvider({ children }) {
  const { id } = useParams();
  const [board, setBoard] = useState(null);
  const [lists, setLists] = useState([]);
  const [tasksByList, setTasksByList] = useState({});
  const [loading, setLoading] = useState(true);

  const loadBoard = async () => {
    if (!id) return;
    
    setLoading(true);
    try {
      const [boardRes, listsRes] = await Promise.all([
        getBoard(id), 
        getLists(id)
      ]);
      
      const sortedLists = (listsRes.data || [])
        .slice()
        .sort((a, b) => (a.position || 9999) - (b.position || 9999));
      
      setBoard(boardRes.data);
      setLists(sortedLists);

      
      const taskEntries = await Promise.all(
        sortedLists.map(async (list) => {
          const tasksRes = await getTasks(id, list.id);
          return [list.id, tasksRes.data || []];
        })
      );
      
      setTasksByList(Object.fromEntries(taskEntries));
    } catch (error) {
      console.error('Failed to load board:', error);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadBoard();
  }, [id]);

  // List operations
  const handleCreateList = async (attrs) => {
    await createList(id, attrs);
    await loadBoard();
  };

  const handleUpdateList = async (listId, attrs) => {
    await updateList(id, listId, attrs);
    await loadBoard();
  };

  const handleDeleteList = async (listId) => {
    await deleteList(id, listId);
    await loadBoard();
  };

  // Task operations
  const handleCreateTask = async (listId, attrs) => {
    await createTask(id, listId, attrs);
    await loadBoard();
  };

  const handleUpdateTask = async (listId, taskId, attrs) => {
    await updateTask(id, listId, taskId, attrs);
    await loadBoard();
  };

  const handleDeleteTask = async (listId, taskId) => {
    await deleteTask(id, listId, taskId);
    await loadBoard();
  };

  const getTasksForList = (listId) => tasksByList[listId] || [];

  return (
    <BoardContext.Provider
      value={{
        board,
        lists,
        tasksByList,
        loading,
        createList: handleCreateList,
        updateList: handleUpdateList,
        deleteList: handleDeleteList,
        createTask: handleCreateTask,
        updateTask: handleUpdateTask,
        deleteTask: handleDeleteTask,
        getTasksForList,
        refreshBoard: loadBoard,
      }}
    >
      {children}
    </BoardContext.Provider>
  );
}

export const useBoard = () => {
  const context = useContext(BoardContext);
  if (!context) {
    throw new Error('useBoard must be used within a BoardProvider');
  }
  return context;
};