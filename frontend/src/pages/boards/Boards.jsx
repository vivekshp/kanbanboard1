import { useState, useEffect } from 'react';
import { getBoards, createBoard, updateBoard, deleteBoard } from '../../lib/api';
import './boards.css';
import { Link } from 'react-router-dom';


export default function Boards() {
  const [boards, setBoards] = useState([]);
  const [loading, setLoading] = useState(true);
  const [showForm, setShowForm] = useState(false);
  const [editingBoard, setEditingBoard] = useState(null);
  const [formData, setFormData] = useState({ title: '', description: '' });

  useEffect(() => {
    loadBoards();
  }, []);

  const loadBoards = async () => {
    try {
      const response = await getBoards();
      setBoards(response.data || []);
    } catch (error) {
      console.error('Failed to load boards:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      if (editingBoard) {
        await updateBoard(editingBoard.id, formData);
      } else {
        await createBoard(formData);
      }
      await loadBoards();
      resetForm();
    } catch (error) {
      console.error('Failed to save board:', error);
    }
  };

  const handleEdit = (board) => {
    setEditingBoard(board);
    setFormData({ title: board.title, description: board.description || '' });
    setShowForm(true);
  };

  const handleDelete = async (id) => {
    if (window.confirm('Are you sure you want to delete this board?')) {
      try {
        await deleteBoard(id);
        await loadBoards();
      } catch (error) {
        console.error('Failed to delete board:', error);
      }
    }
  };

  const resetForm = () => {
    setFormData({ title: '', description: '' });
    setEditingBoard(null);
    setShowForm(false);
  };

  if (loading) return <div className="loading">Loading boards...</div>;

  return (
    <div className="boards-container">
      <div className="boards-header">
        <h1>My Boards</h1>
        <div className="boards-actions">
      <button className="btn-primary" onClick={() => setShowForm(true)}>
        Create Board
      </button>
      <Link to="/" className="btn-small">
        ← Back to Home
      </Link>
    </div>
      </div>

      {showForm && (
        <div className="board-form-overlay">
          <div className="board-form">
            <h2>{editingBoard ? 'Edit Board' : 'Create Board'}</h2>
            <form onSubmit={handleSubmit}>
              <div className="form-group">
                <label>Title</label>
                <input
                  type="text"
                  value={formData.title}
                  onChange={(e) => setFormData({ ...formData, title: e.target.value })}
                  required
                />
              </div>
              <div className="form-group">
                <label>Description</label>
                <textarea
                  value={formData.description}
                  onChange={(e) => setFormData({ ...formData, description: e.target.value })}
                  rows="3"
                />
              </div>
              <div className="form-actions">
                <button type="submit" className="btn-primary">
                  {editingBoard ? 'Update' : 'Create'}
                </button>
                <button type="button" onClick={resetForm} className="btn-secondary">
                  Cancel
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      <div className="boards-grid">
        {boards.length === 0 ? (
          <div className="empty-state">
            <p>No boards yet. Create your first board!</p>
          </div>
        ) : (
          boards.map((board) => (
            <div key={board.id} className="board-card">
              <h3><Link to={`/boards/${board.id}`}>{board.title}</Link></h3>
              {board.description && <p>{board.description}</p>}
              <div className="board-actions">
                <button onClick={() => handleEdit(board)} className="btn-small">
                  Edit
                </button>
                <button onClick={() => handleDelete(board.id)} className="btn-small btn-danger">
                  Delete
                </button>
              </div>
            </div>
          ))
        )}
      </div>
    </div>
  );
}