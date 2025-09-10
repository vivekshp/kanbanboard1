import { useAuth } from '../../context/AuthContext';
import { logout as apiLogout } from '../../lib/api';
import './navbar.css';

export default function Navbar() {
  const { user, setUser } = useAuth();

  const onLogout = async () => {
    await apiLogout();
    setUser(null);
  };

  return (
    <header className="nav">
      <div className="nav-inner container">
        <div className="nav-brand">Kanban</div>
        <div className="nav-right">
          {user ? (
            <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
              <span className="nav-user">{user.name}</span>
              <button className="btn-small" onClick={onLogout}>Logout</button>
            </div>
          ) : null}
        </div>
      </div>
    </header>
  );
}