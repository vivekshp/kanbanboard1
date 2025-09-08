import { useAuth } from '../../context/AuthContext';
import { logout as apiLogout } from '../../lib/api';
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
        <p style={{ color: 'var(--muted)' }}>You’re logged in. Next we’ll add boards, lists, and cards.</p>
        <button className="primary-btn" onClick={onLogout}>Logout</button>
      </div>
    </section>
  );
}