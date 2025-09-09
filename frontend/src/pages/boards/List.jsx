import { useState } from 'react';
import './lists.css';

export default function List({ list, onUpdate, onDelete, children }) {
  const [editing, setEditing] = useState(false);
  const [title, setTitle] = useState(list.title || '');

  const handleSubmit = async (e) => {
    e.preventDefault();
    await onUpdate(list.id, { title });
    setEditing(false);
  };

  return (
    <div className="list">
      <div className="list-header">
        {editing ? (
          <form onSubmit={handleSubmit} className="list-title-form">
            <input
              className="list-title-input"
              value={title}
              onChange={(e) => setTitle(e.target.value)}
              autoFocus
            />
          </form>
        ) : (
          <h3 className="list-title" onClick={() => setEditing(true)} title="Click to rename">
            {list.title}
          </h3>
        )}
        <button className="list-more" onClick={() => onDelete(list.id)} title="Delete list">×</button>
      </div>

      <div className="list-body">
        
        {children}
      </div>

      <div className="list-footer">
        <button className="btn-link" onClick={() => {}}>
          + Add task
        </button>
      </div>
    </div>
  );
}