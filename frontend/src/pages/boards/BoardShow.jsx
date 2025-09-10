import { useState } from 'react';
import { Link } from 'react-router-dom';
import { useBoard } from '../../context/BoardContext';
import List from './List';
import './boards.css';
import './lists.css';
import './boardshow.css';

export default function BoardShow() {
  const { board, lists, loading, createList } = useBoard();
  const [newTitle, setNewTitle] = useState('');
  const [newPosition, setNewPosition] = useState('');
  const [newLimit, setNewLimit] = useState('');

  const handleCreateList = async (e) => {
    e.preventDefault();
    const attrs = {
      title: newTitle.trim(),
      position: newPosition ? Number(newPosition) : undefined,
      limit: newLimit ? Number(newLimit) : undefined,
    };
    if (!attrs.title) return;
    
    await createList(attrs);
    setNewTitle('');
    setNewPosition('');
    setNewLimit('');
  };

  if (loading) return <div className="loading">Loading...</div>;
  if (!board) return <div className="empty-state">Board not found.</div>;

  return (
    <div className="boardshow-wrap">
      <div className="boardshow-header">
        <h1 className="boardshow-title">{board.title}</h1>
        <div className="boardshow-actions">
          <Link to="/boards" className="btn-small">Back</Link>
        </div>
      </div>

      <form onSubmit={handleCreateList} className="boardshow-newlist">
        <input 
          className="boardshow-input" 
          placeholder="Title" 
          value={newTitle} 
          onChange={(e) => setNewTitle(e.target.value)} 
        />
        <input 
          className="boardshow-input" 
          placeholder="Position" 
          type="number" 
          min="1" 
          value={newPosition} 
          onChange={(e) => setNewPosition(e.target.value)} 
        />
        <input 
          className="boardshow-input" 
          placeholder="Limit" 
          type="number" 
          min="1" 
          value={newLimit} 
          onChange={(e) => setNewLimit(e.target.value)} 
        />
        <button className="boardshow-btn" type="submit">Add List</button>
      </form>

      <div className="lists">
        {lists.map((list) => (
          <List key={list.id} list={list} />
        ))}
      </div>
    </div>
  );
}