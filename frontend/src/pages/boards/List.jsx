import { useState } from 'react';
import { useBoard } from '../../context/BoardContext';
import TaskCard from './TaskCard';
import TaskModal from './TaskModal';
import './lists.css';
import './tasks.css';

export default function List({ list }) {
  const {board,lists, getTasksForList, createTask, updateTask, deleteTask, updateList, deleteList } = useBoard();
  const [editing, setEditing] = useState(false);
  const [title, setTitle] = useState(list.title || '');
  const [openCreate, setOpenCreate] = useState(false);
  const [openEdit, setOpenEdit] = useState(false);
  const [selectedTask, setSelectedTask] = useState(null);

  const tasks = getTasksForList(list.id);
  const isFull = Number.isInteger(list?.limit) && tasks.length >= list.limit;

  const openEditModal = (task) => {
    setSelectedTask(task);
    setOpenEdit(true);
  };

  const createViaModal = async (payload) => {
    const targetListId = payload.list_id || list.id;
    await createTask(targetListId, {
      title: payload.title.trim(),
      description: payload.description?.trim() || undefined,
      due_date: payload.due_date || undefined,
    });
  };

  const handleEditSave = async (payload) => {
    await updateTask(list.id, selectedTask.id, {
      title: payload.title,
      description: payload.description,
      due_date: payload.due_date,
      list_id: payload.list_id,
    });
  };

  const handleDeleteList = async () => {
    if (confirm('Delete list?')) {
      await deleteList(list.id);
    }
  };

  return (
    <div className="list">
      <div className="list-header">
        <h3 className="list-title" onClick={() => setEditing(true)} title="Click to rename">
          {list.title} {list.limit ? `(${tasks.length}/${list.limit})` : null}
        </h3>
        <div style={{ display: 'flex', gap: 6 }}>
          <button
            className="btn-link"
            onClick={() => !isFull && setOpenCreate(true)}
            disabled={isFull}
            title={isFull ? `Limit reached (${tasks.length}/${list.limit})` : 'Add task'}
            style={isFull ? { opacity: 0.6, cursor: 'not-allowed' } : undefined}
          >
            + Add task
          </button>
          <button className="list-more" onClick={handleDeleteList} title="Delete list">×</button>
        </div>
      </div>

      <div className="list-body">
        {tasks.map((task) => (
          <TaskCard
            key={task.id}
            task={task}
            onClick={openEditModal}
            onUpdate={(attrs) => updateTask(list.id, task.id, attrs)}
            onDelete={(taskId) => deleteTask(list.id, taskId)}
            boardId={board?.id}
          />
        ))}
      </div>

    
      <TaskModal
        open={openCreate}
        onClose={() => setOpenCreate(false)}
        lists={lists || []}
        defaultListId={list.id}
        mode="create"
        onCreate={createViaModal}
        boardId={board?.id}
      />

      
      <TaskModal
        open={openEdit}
        onClose={() => setOpenEdit(false)}
        lists={lists || []}
        defaultListId={list.id}
        mode="edit"
        initial={selectedTask ? { ...selectedTask, list_id: list.id } : null}
        onUpdate={handleEditSave}
        boardId={board?.id}
      />
    </div>
  );
}