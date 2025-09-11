import { useEffect, useState } from 'react';
import { getInvites, respondInvite, deleteInvite } from '../../lib/api';
import { useNavigate } from 'react-router-dom';

export default function Invites() {
  const [items, setItems] = useState([]);
  const [loading, setLoading] = useState(true);
  const [err, setErr] = useState('');
  const navigate = useNavigate();


  const load = async () => {
    setLoading(true); setErr('');
    try {
      const res = await getInvites();
      setItems(res.data || res);
    } catch (e) {
      setErr(e?.message || 'Failed to load invites');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => { load(); }, []);

  const accept = async (id) => { await respondInvite(id, 'accepted'); await load(); };
  const decline = async (id) => { await deleteInvite(id); await load(); };

  if (loading) return <div className="loading">Loading...</div>;
  return (
    <div className="container">
      <div style={{ display:'flex', justifyContent:'space-between', alignItems:'center', marginBottom:16 }}>
        <h2>Board Invites</h2>
        <button className="btn-small" onClick={() => navigate('/')}>← Back to Home</button>
      </div>
      {err && <div style={{ color: 'var(--danger)', fontSize: 13 }}>{err}</div>}
      {!items.length ? <div className="empty-state">No invites</div> : (
        <div style={{ display:'grid', gap:12 }}>
          {items.map(inv => (
            <div key={inv.id} style={{ display:'flex', justifyContent:'space-between', alignItems:'center', border:'1px solid var(--border)', borderRadius:8, padding:10, background:'#fff' }}>
              <div>
                <div style={{ fontWeight:600 }}>{inv.board?.title || `Board #${inv.board_id}`}</div>
                <div style={{ fontSize:13, color:'var(--muted)' }}>Role: {inv.role} · Status: {inv.status}</div>
              </div>
              <div style={{ display:'flex', gap:8 }}>
                <button className="btn-primary" onClick={() => accept(inv.id)}>Accept</button>
                <button className="btn-secondary" onClick={() => decline(inv.id)}>Decline</button>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}