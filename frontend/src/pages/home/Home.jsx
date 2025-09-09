import { useAuth } from '../../context/AuthContext';
import { logout as apiLogout } from '../../lib/api';
import { Link } from 'react-router-dom';
import './home.css';

export default function Home() {
  const { user, setUser } = useAuth();

  const onLogout = async () => {
    await apiLogout();
    setUser(null);
  };

  return (
    <section className="home-section">
      <div className="panel">
        <h2 style={{ margin: 0 }}>Welcome, {user?.name}</h2>
        <p style={{ color: 'var(--muted)' }}>Manage your Kanban baords and tasks.</p>
        <div style={{ display: 'flex', gap: '12px', marginTop: '16px' }}>
          <Link to="/boards" className="primary-btn">View Boards</Link>
          <button className="primary-btn" onClick={onLogout}>Logout</button>
        </div>
      </div>
    </section>
  );
}