import { useEffect, useState } from 'react';
import { getHistories } from '../../lib/api';
import { useNavigate } from 'react-router-dom';

export default function HistoryPage() {
  const [items, setItems] = useState([]);
  const [loading, setLoading] = useState(true);     
  const [loadingMore, setLoadingMore] = useState(false); 
  const [err, setErr] = useState('');
  const navigate = useNavigate();
  const [hasMore, setHasMore] = useState(true);
  const [offset, setOffset] = useState(0);
  const limit = 20;

  const load = async (isFirst = false) => {
    if (!hasMore) return;

    if (isFirst) setLoading(true);
    else setLoadingMore(true);

    try {
      const res = await getHistories({ limit, offset: isFirst ? 0 : offset });
      if (!res || res.length === 0) {
        setHasMore(false);
      } else {
        setItems(prev => (isFirst ? res : [...prev, ...res]));
        setOffset(prev => prev + res.length);
      }
    } catch (e) {
      setErr(e?.message || 'Failed to load history');
    } finally {
      if (isFirst) setLoading(false);
      else setLoadingMore(false);
    }
  };

  useEffect(() => { load(true); }, []);

  useEffect(() => {
    const handleScroll = () => {
      if (
        window.innerHeight + window.scrollY >= document.body.offsetHeight - 300 &&
        !loadingMore &&
        hasMore
      ) {
        load(false);
      }
    };
    window.addEventListener('scroll', handleScroll);
    return () => window.removeEventListener('scroll', handleScroll);
  }, [loadingMore, hasMore]);

  if (loading) return <div className="loading">Loading...</div>;

  return (
    <div className="container">
      <div style={{ display:'flex', justifyContent:'space-between', alignItems:'center', marginBottom:16 }}>
        <h2>History / Activity</h2>
        <button className="btn-small" onClick={() => navigate('/')}>← Back to Home</button>
      </div>

      {err && <div style={{ color: 'var(--danger)', fontSize: 13 }}>{err}</div>}

      {items.length === 0 ? (
        <div className="empty-state">No activity found</div>
      ) : (
        <div style={{ overflowX: 'auto', background: '#fff', border: '1px solid var(--border)', borderRadius: 8 }}>
          <table style={{ width: '100%', borderCollapse: 'collapse' }}>
            <thead>
              <tr style={{ textAlign: 'left' }}>
                <th style={{ padding: 12, borderBottom: '1px solid var(--border)' }}>Record</th>
                <th style={{ padding: 12, borderBottom: '1px solid var(--border)' }}>Action</th>
                <th style={{ padding: 12, borderBottom: '1px solid var(--border)' }}>Modified By</th>
                <th style={{ padding: 12, borderBottom: '1px solid var(--border)' }}>Modified To</th>
                <th style={{ padding: 12, borderBottom: '1px solid var(--border)' }}>When</th>
              </tr>
            </thead>
            <tbody>
              {items.map(h => (
                <tr key={h.id}>
                  <td style={{ padding: 12, borderBottom: '1px solid var(--border)' }}>
                    <div style={{ fontWeight: 600 }}>{h.record_type}</div>
                    <div style={{ color: 'var(--muted)', fontSize: 13 }}>
                      ID: {h.record_id}
                    </div>
                  </td>
                  <td style={{ padding: 12, borderBottom: '1px solid var(--border)' }}>
                    {h.action}
                  </td>
                  <td style={{ padding: 12, borderBottom: '1px solid var(--border)' }}>
                    {h.modified_by ? (
                      <>
                        <div style={{ fontWeight: 600 }}>{h.modified_by.name}</div>
                        <div style={{ color: 'var(--muted)', fontSize: 13 }}>{h.modified_by.email}</div>
                      </>
                    ) : (
                      <div style={{ color: 'var(--muted)' }}>System</div>
                    )}
                  </td>
                  <td style={{ padding: 12, borderBottom: '1px solid var(--border)', maxWidth: 420 }}>
                    {h.modified_to && Object.keys(h.modified_to).length > 0 ? (
                      <div style={{ fontSize: 13 }}>
                        {Object.entries(h.modified_to).map(([k,v]) => {
                          if (Array.isArray(v) && v.length === 2) {
                            return <div key={k}><strong>{k}:</strong> {String(v[0])} → <strong>{String(v[1])}</strong></div>;
                          }
                          if (typeof v === 'object') {
                            return <div key={k}><strong>{k}:</strong> {JSON.stringify(v)}</div>;
                          }
                          return <div key={k}><strong>{k}:</strong> {String(v)}</div>;
                        })}
                      </div>
                    ) : (
                      <div style={{ color: 'var(--muted)' }}>—</div>
                    )}
                  </td>
                  <td style={{ padding: 12, borderBottom: '1px solid var(--border)' }}>
                    {new Date(h.time || h.created_at).toLocaleString()}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
          {loadingMore && <div style={{ padding: 12, textAlign: 'center' }}>Loading more…</div>}
        </div>
      )}
    </div>
  );
}
