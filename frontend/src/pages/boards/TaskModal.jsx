import { useEffect, useState } from 'react';
import './modal.css';
import { searchBoardMembers, assignTask } from '../../lib/api'; // assignTask: POST /tasks/:task_id/task_assignments
import { useBoard } from '../../context/BoardContext';


const toDateInput = (v) => {
  if (!v) return '';
  try { return new Date(v).toISOString().slice(0, 10); } catch { return ''; }
};

export default function TaskModal({
  open,
  onClose,
  lists = [],
  defaultListId,
  mode = 'create',
  initial = null,
  onCreate,
  onUpdate,
  boardId
}) {
  const [form, setForm] = useState({
    title: '',
    description: '',
    due_date: '',
    list_id: defaultListId,
  });
  const [err, setErr] = useState('');
  const [search, setSearch] = useState('');
  const [searchResults, setSearchResults] = useState([]);
  const [assignLoading, setAssignLoading] = useState(false);
  const { refreshBoard } = useBoard();



  const handleSearch = async (q) => {
    setSearch(q);
    if (q.length < 2) return setSearchResults([]);
    const res = await searchBoardMembers(boardId, q);
    setSearchResults(res.data || []);
  };

  const handleAssign = async (userId) => {
    setAssignLoading(true);
    try {
      await assignTask(boardId, defaultListId, initial.id, userId); // You need to add this to your api.js
      await refreshBoard();
      setAssignLoading(false);
      onClose(); // or reload modal/task
    } catch (err) {
      setAssignLoading(false);
      setErr('Failed to assign');
    }
  };

  useEffect(() => {
    if (!open) return;
    setErr('');
    if (mode === 'edit' && initial) {
      setForm({
        title: initial.title || '',
        description: initial.description || '',
        due_date: toDateInput(initial.due_date),
        list_id: initial.list_id ?? defaultListId ?? (lists[0]?.id ?? ''),
      });
    } else {
      setForm({
        title: '',
        description: '',
        due_date: '',
        list_id: defaultListId ?? (lists[0]?.id ?? ''),
      });
    }
  }, [open, mode, initial, defaultListId, lists]);

  if (!open) return null;

  const submit = async (e) => {
    e.preventDefault();
    setErr('');
    if (!form.title.trim()) return;

    const payload = {
      title: form.title.trim(),
      description: form.description?.trim() || undefined,
      due_date: form.due_date || null,
      list_id: form.list_id,
    };

    try {
      if (mode === 'edit' && initial) {
        await onUpdate(payload);
      } else {
        await onCreate(payload);
      }
      onClose();
    } catch (err) {
      const data = err?.response?.data;
      const msg = Array.isArray(data?.errors) ? data.errors.join(', ')
        : data?.error || data?.message || err.message;
      setErr(msg);
    }
  };

  return (
    <div className="modal-backdrop" onClick={onClose}>
      <div className="modal-card" onClick={(e) => e.stopPropagation()}>
        <div className="modal-head">
          <h3>{mode === 'edit' ? 'Edit Task' : 'Create Task'}</h3>
          <button className="modal-close" onClick={onClose}>×</button>
        </div>

        <form className="modal-form" onSubmit={submit}>
          {err && <div style={{ color: 'var(--danger)', fontSize: 13 }}>{err}</div>}

          <div className="field">
            <label>Title</label>
            <input
              value={form.title}
              onChange={(e) => setForm({ ...form, title: e.target.value })}
              autoFocus
            />
          </div>

          <div className="field">
            <label>Description</label>
            <textarea
              rows={3}
              value={form.description}
              onChange={(e) => setForm({ ...form, description: e.target.value })}
            />
          </div>

          <div className="row">
            <div className="field">
              <label>Due date</label>
              <input
                type="date"
                value={form.due_date}
                onChange={(e) => setForm({ ...form, due_date: e.target.value })}
              />
            </div>

            <div className="field">
              <label>Status (List)</label>
              <select
                value={form.list_id ?? ''}
                onChange={(e) => setForm({ ...form, list_id: Number(e.target.value) })}
              >
                {(lists || []).map((l) => (
                  <option key={l.id} value={l.id}>{l.title}</option>
                ))}
              </select>
            </div>
          </div>

          {mode === 'edit' && initial && (
            <div className="field">
              <label>Assigned To</label>
              {initial.task_assignments && initial.task_assignments.length > 0 ? (
                <ul>
                  {initial.task_assignments.map(a => (
                    <li key={a.id}>
                      {a.user.name} ({a.user.email})
                      <div style={{ fontSize: 13, color: '#888', marginLeft: 8 }}>
                        Assigned By: {a.assigned_by.name} ({a.assigned_by.email})
                        <span style={{ marginLeft: 12 }}>
                          {new Date(a.created_at).toLocaleString()}
                        </span>
                      </div>
                    </li>
                  ))}
                </ul>
              ) : (
                <>
                  <input
                    type="text"
                    placeholder="Search user to assign"
                    value={search}
                    onChange={e => handleSearch(e.target.value)}
                  />
                  {searchResults.length > 0 && (
                    <ul>
                      {searchResults.map(u => (
                        <li key={u.id}>
                          {u.name} ({u.email})
                          <button disabled={assignLoading} onClick={() => handleAssign(u.id)}>
                            Assign
                          </button>
                        </li>
                      ))}
                    </ul>
                  )}
                </>
              )}
            </div>
          )}
          <div className="actions">
            <button type="submit" className="btn-primary">
              {mode === 'edit' ? 'Save' : 'Create'}
            </button>
            <button type="button" className="btn-secondary" onClick={onClose}>Cancel</button>
          </div>
        </form>
      </div>
    </div>
  );
}