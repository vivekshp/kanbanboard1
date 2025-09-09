import { useEffect, useState } from 'react';
import { useParams, Link } from 'react-router-dom';
import { getBoard, getLists, createList, updateList, deleteList } from '../../lib/api';
import List from './List';
import './boardshow.css';
import './lists.css';

export default function BoardShow() {
  const { id } = useParams();
  const [board, setBoard] = useState(null);
  const [lists, setLists] = useState([]);
  const [loading, setLoading] = useState(true);
  const [newTitle, setNewTitle] = useState('');

  const load = async () => {
    setLoading(true);
    try {
      const [b, l] = await Promise.all([getBoard(id), getLists(id)]);
      setBoard(b.data);
      setLists(l.data || []);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => { load(); }, [id]);

  const handleCreateList = async (e) => {
    e.preventDefault();
    if (!newTitle.trim()) return;
    await createList(id, {  title: newTitle  });
    setNewTitle('');
    await load();
  };

  const handleUpdateList = async (listId, payload) => {
    await updateList(id, listId, { payload });
    await load();
  };

  const handleDeleteList = async (listId) => {
    if (!confirm('Delete this list?')) return;
    await deleteList(id, listId);
    await load();
  };

  if (loading) return <div className="loading">Loading...</div>;
  if (!board) return <div className="empty-state">Board not found.</div>;

  return (
    <div className="boards-container">
      <div className="boards-header">
        <h1>{board.title}</h1>
        <Link to="/boards" className="btn-small">Back</Link>
      </div>

      <form onSubmit={handleCreateList} style={{ marginBottom: 12, display: 'flex', gap: 8 }}>
        <input
          value={newTitle}
          onChange={(e) => setNewTitle(e.target.value)}
          placeholder="New list title"
          style={{ flex: 1, padding: '10px 12px', border: '1px solid var(--border)', borderRadius: 8 }}
        />
        <button className="btn-primary" type="submit">Add List</button>
      </form>

      <div className="lists">
        {lists.map((lst) => (
          <List
            key={lst.id}
            list={lst}
            onUpdate={handleUpdateList}
            onDelete={handleDeleteList}
          >
            
          </List>
        ))}
      </div>
    </div>
  );
}