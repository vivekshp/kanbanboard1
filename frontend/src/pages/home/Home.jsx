import { useAuth } from '../../context/AuthContext';
import { Link } from 'react-router-dom';
import './home.css';

export default function Home() {
  const { user } = useAuth();

  return (
    <section className="home-section">
      <div className="panel">
        <h2 style={{ margin: 0 }}>Welcome, {user?.name}</h2>
        <p style={{ color: 'var(--muted)' }}>Manage your Kanban boards and tasks.</p>
        <div style={{ display: 'flex', gap: '12px', marginTop: '16px' }}>
          <Link to="/boards" className="primary-btn">View Boards</Link>
          <Link to="/invites" className="primary-btn">Board Invites</Link>
          <Link to="/history" className="primary-btn">View History</Link>
        </div>
      </div>
    </section>
  );
}