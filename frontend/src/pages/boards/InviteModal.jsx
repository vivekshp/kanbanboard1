import { useEffect, useState } from 'react';
import { searchUsers, inviteMember } from '../../lib/api';
import './modal.css';

export default function InviteModal({ open, onClose, boardId, canInvite, defaultRole = 'member' }) {
  const [q, setQ] = useState('');
  const [role, setRole] = useState(defaultRole);
  const [results, setResults] = useState([]);
  const [err, setErr] = useState('');
  const [loading, setLoading] = useState(false);

  useEffect(() => { if (!open) { setQ(''); setResults([]); setErr(''); setRole(defaultRole); } }, [open, defaultRole]);

  useEffect(() => {
    let t; if (!open) return;
    t = setTimeout(async () => {
      if (!q.trim()) { setResults([]); return; }
      try { const res = await searchUsers(q.trim()); setResults(res.data || res); } catch { setResults([]); }
    }, 300);
    return () => clearTimeout(t);
  }, [q, open]);

  if (!open) return null;
  if (!canInvite) return null;

  const sendInvite = async (userId) => {
    setLoading(true); setErr('');
    try {
      await inviteMember(boardId, { userId, role });
      onClose?.();
    } catch (e) {
      setErr(e?.message || 'Failed to invite');
    } finally {
      setLoading(false);
    }
  };
  

  return (
    <div className="modal-backdrop" onClick={onClose}>
      <div className="modal-card" onClick={(e) => e.stopPropagation()}>
        <div className="modal-head">
          <h3>Invite to Board</h3>
          <button className="modal-close" onClick={onClose}>×</button>
        </div>
        <div className="modal-form">
          {err && <div style={{ color: 'var(--danger)', fontSize: 13 }}>{err}</div>}
          <div className="field">
            <label>Search by name or email</label>
            <input value={q} onChange={(e) => setQ(e.target.value)} placeholder="Type to search..." />
          </div>
          <div className="field">
            <label>Role</label>
            <select value={role} onChange={(e) => setRole(e.target.value)}>
              <option value="member">Member</option>
              <option value="admin">Admin</option>
              <option value="viewer">Viewer</option>
            </select>
          </div>
          <div className="field">
          {(results || []).map(u => (
  <div key={u.id} style={{ display:'flex', justifyContent:'space-between', alignItems:'center', padding:'6px 0', borderBottom:'1px solid var(--border)' }}>
    <div>
      <div style={{ fontWeight:600 }}>{u.name}</div>
      <div style={{ fontSize:12, color:'var(--muted)' }}>{u.email}</div>
    </div>
    <button
      className="btn-primary"
      disabled={loading}
      onClick={() => sendInvite(u.id)}
    >
      Invite
    </button>
  </div>
))}

            {!results.length && q && <div style={{ color:'var(--muted)', fontSize:13 }}>No users found</div>}
          </div>
        </div>
      </div>
    </div>
  );
}